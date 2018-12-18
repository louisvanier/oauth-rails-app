class NavMenuBuilder
  include Rails.application.routes.url_helpers

  ADMIN_ROLE = 'admin'
  USER_ROLE = 'user'

  def initialize(user_role)
    @user_role = user_role
  end

  def menu_items
    send("#{@user_role}_menu_items")
  end

  private

  def admin_menu_items
    [
      NavMenuItem.new(label: 'Users', navigation_path: users_manage_path),
      NavMenuItem.new(label: 'Revenues', navigation_path: revenue_shares_index_path)
    ]
  end

  def user_menu_items
    [
      NavMenuItem.new(label: 'Revenues', navigation_path: prepare_revenue_shares_path)
    ]
  end
end
