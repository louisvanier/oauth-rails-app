class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_tenant

  def new_session_path(_)
    users_login_url
  end

  def current_tenant
    @current_tenant ||= Tenant.from_subdomain(subdomain: Apartment::Tenant.current)
  end

  def is_admin?
    current_tenant.is_admin?(current_user.email)
  end
end
