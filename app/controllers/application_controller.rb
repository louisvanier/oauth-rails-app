class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_tenant

  def is_public_apartment?
    Apartment::Tenant.current == 'public'
  end

  def new_session_path(_)
  	new_user_session_path
  end

  def current_tenant
    @curren_tenant ||= begin
      return NilTenant.new if is_public_apartment?
      Tenant.find_by(subdomain: Apartment::Tenant.current)
    end
  end

  def is_admin?
    current_tenant.is_admin?(current_user.email)
  end
end
