require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  TEST_SUBDOMAIN = 'black-metal'

  test '#login does not require authentication as it is the landing page' do
    get users_login_url
    assert_response :ok
  end

  test '#index requires authentication' do
    get users_manage_url
    assert_redirected_to new_user_session_url
  end

  test "#index Non-admin users are unauthorized" do
    create_tenant
    create_and_sign_in_user

    Apartment::Tenant.switch(TEST_SUBDOMAIN) do
      get users_manage_url
      assert_response :unauthorized
      assert_empty response.body
    end
  end

  test '#delete requires authentication' do
    delete delete_user_url(create(:user))
    assert_redirected_to new_user_session_url
  end

  test '#delete Non-admin users are unauthorized' do
    create_tenant
    create_and_sign_in_user

    Apartment::Tenant.switch(TEST_SUBDOMAIN) do
      delete delete_user_url(create(:user))
      assert_response :unauthorized
      assert_empty response.body
    end
  end

  test '#delete deletes the user' do
    create_tenant
    Apartment::Tenant.switch(TEST_SUBDOMAIN) do
      user = create(:user)
      create_and_sign_in_user(admin: true)
      delete delete_user_url(user)
      assert_nil User.find_by(id: user.id)
    end
  end

  test '#delete returns a 404 if the user des not exist' do
    create_tenant
    Apartment::Tenant.switch(TEST_SUBDOMAIN) do
      user = create(:user)
      create_and_sign_in_user(admin: true)
      delete delete_user_url(id: 999)
      assert_response :not_found
    end
  end

  test '#approve requires authentication' do
    patch approve_user_url(create(:user))
    assert_redirected_to new_user_session_url
  end

  test '#approve Non-admin users are unauthorized' do
    create_tenant
    create_and_sign_in_user

    Apartment::Tenant.switch(TEST_SUBDOMAIN) do
      patch approve_user_url(create(:user))
      assert_response :unauthorized
      assert_empty response.body
    end
  end

  test '#approve sets the approved flag to true for the user' do
    create_tenant
    Apartment::Tenant.switch(TEST_SUBDOMAIN) do
      user = create(:user)
      create_and_sign_in_user(admin: true)
      patch approve_user_url(user)
      assert User.find_by(id: user.id).approved
    end
  end

  test '#approve returns a 404 if the user des not exist' do
    create_tenant
    Apartment::Tenant.switch(TEST_SUBDOMAIN) do
      user = create(:user)
      create_and_sign_in_user(admin: true)
      patch approve_user_url(id: -1)
      assert_response :not_found
    end
  end

  private

  def create_tenant(subdomain: TEST_SUBDOMAIN)
    create(:tenant, subdomain: subdomain, admins: ['black@metal.com'])
    Apartment::Tenant.create(subdomain)
  end

  def create_and_sign_in_user(admin: false)
    email = admin ? 'black@metal.com' : 'death@metal.com'
    user = create(:user, email: email)
    sign_in user
  end

end
