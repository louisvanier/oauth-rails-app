require 'test_helper'

class TenantTest < ActiveSupport::TestCase
  test 'Tenant#from_subdomain returns a NilTenant if the subdomain is the Tenant::PUBLIC_APARTMENT' do
    assert_instance_of NilTenant, Tenant.from_subdomain(subdomain: Tenant::PUBLIC_APARTMENT)
  end

  test 'Tenant#from_subdomain returns nil if not the public tenant and not existing' do
    assert_nil Tenant.from_subdomain(subdomain: 'rainbows-and-unicorns')
  end

  test 'Tenant#from_subdomain returns the tenant by subdomain lookup' do
    new_tenant = create(:tenant, subdomain: 'heavy-metal')
    assert_equal new_tenant, Tenant.from_subdomain(subdomain: 'heavy-metal')
  end

  test '#is_admin? returns true if the email address is in the admins array' do
    assert create(:tenant, admins: ['abcdef@example.com']).is_admin?('abcdef@example.com')
  end

  test '#is_admin? returns false if the email address is not in the admins array' do
    refute create(:tenant, admins: ['admins@example.com']).is_admin?('abcdef@example.com')
  end

  test 'NilTenant has an empty subdomain' do
    assert_equal '', NilTenant.new.subdomain
  end

  test 'NilTenant is_admin? looks at the env variable PUBLIC_TENANT_ADMIN' do
    ENV.expects(:fetch).with('PUBLIC_TENANT_ADMIN').returns('admins@example.com')
    assert NilTenant.new.is_admin?('admins@example.com')
  end

  test 'NilTenant is_admin? defaults to admin@tehg4m3 when the env variable PUBLIC_TENANT_ADMIN is not set' do
    ENV.expects(:fetch).with('PUBLIC_TENANT_ADMIN').returns(nil)
    assert NilTenant.new.is_admin?('admin@tehg4m3.com')
  end

  test 'NilTenant is_admin? returns false for email not in the ENV variable PUBLIC_TENANT_ADMIN and not equal to admin@tehg4m3.com' do
    ENV.expects(:fetch).with('PUBLIC_TENANT_ADMIN').returns('admins@example.com')
    refute NilTenant.new.is_admin?('huehuehue@example.br')
  end
end
