module UsersHelper
  def user_actions
    actions = []
    actions << users_path if is_admin?
    actions
  end
end
