ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/minitest'

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods

  def create_tenant(subdomain:)
    create(:tenant, subdomain: subdomain, admins: ["#{subdomain.split('-')[0]}@#{subdomain.split('-')[1]}.com"])
    Apartment::Tenant.create(subdomain)
  end

  def create_and_sign_in_user(subdomain: ,admin: false)
    email = admin ? "#{subdomain.split('-')[0]}@#{subdomain.split('-')[1]}.com" : 'death@metal.com'
    Apartment::Tenant.switch(subdomain) do
      user = create(:user, email: email)
      sign_in user
    end
  end
end
