class NavMenuBuilder
  include Rails.application.routes.url_helpers

  ADMIN_ROLE = 'admin'
  USER_ROLE = 'user'

  def initialize(user_role)
    @user_role = user_role
  end

  def menu_items
    Hash[send("#{@user_role}_menu_items").group_by(&:category) ]
  end

  private

  def admin_menu_items
    [
      NavMenuItem.new(label: 'Users', navigation_path: users_manage_path),
      NavMenuItem.new(label: 'Revenues', navigation_path: revenue_shares_path)
    ]
  end

  def user_menu_items
    [
      NavMenuItem.new(label: 'add', navigation_path: prepare_revenue_shares_path, category: 'Revenues'),
      NavMenuItem.new(label: 'view all', navigation_path: revenue_shares_mine_path, category: 'Revenues')
    ]
  end
end
