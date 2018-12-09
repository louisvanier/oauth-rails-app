class Tenant < ApplicationRecord
  def is_admin?(email_address)
    admins.include?(email_address)
  end
end

class NilTenant
  def subdomain
    ''
  end

  def is_admin?(email_address)
    email_address == (ENV.fetch('PUBLIC_TENANT_ADMIN') || 'admin@tehg4m3.com')
  end
end
