class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_tenant, :menu_items

  def new_session_path(_)
    users_login_url
  end

  def current_tenant
    @current_tenant ||= Tenant.from_subdomain(subdomain: Apartment::Tenant.current)
  end

  def is_admin?
    current_tenant.is_admin?(current_user.email)
  end

  def menu_items
    NavMenuBuilder.new(user_role).menu_items
  end

  private

  def user_role
    return NavMenuBuilder::ADMIN_ROLE if is_admin?
    NavMenuBuilder::USER_ROLE
  end
end
