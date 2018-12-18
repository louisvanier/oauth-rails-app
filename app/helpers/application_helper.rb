module ApplicationHelper
  def current_tenant
    @current_tenant ||= Tenant.from_subdomain(subdomain: Apartment::Tenant.current)
  end
end
