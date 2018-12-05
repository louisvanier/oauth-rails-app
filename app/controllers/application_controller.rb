class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def is_public_apartment?
    Apartment::Tenant.current == 'public'
  end

  def new_session_path(_)
  	new_user_session_path
  end

  def current_tenant
    return NilTenant if is_public_apartment?
    Tenant.find_by(subdomain: Apartment::Tenant.current)
  end
end
