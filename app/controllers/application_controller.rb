class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_tenant

  def after_sing_in_path_for(user)
    users_login_path
  end

  def new_session_path(_)
  	new_user_session_path
  end

  def current_tenant
    @current_tenant ||= Tenant.from_subdomain(subdomain: Apartment::Tenant.current)
  end

  def is_admin?
    current_tenant.is_admin?(current_user.email)
  end
end
