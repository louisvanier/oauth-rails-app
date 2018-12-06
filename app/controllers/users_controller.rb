class UsersController < ApplicationController
  before_action :authenticate_user!, except: :login
  before_action only: [:index, :delete, :approve] do
    return :unauthorized unless is_admin?
  end

  helper_method  :admin_users, :users_to_approve, :standard_users

  def login
    Rails.logger.info("#{session}")
    @user = current_user
    render :login, layout: 'layouts/login'
  end

  def index
    @users = User.all
    render :index
  end

  def delete
    user_to_delete = User.find_by!(id: params.permit(:id)[:id])
    if user_to_delete.delete
      flash[:notice] = "User #{user_to_delete.email} successfully deleted"
    else
      flash[:warning] = "failure to delete #{user_to_delete.email}"
    end

    @users = User.all
    render :index
  end

  def approve
    User.find_by!(id: params.permit(:id)[:id])
    if user.update_attribute(:approved, true)
      flash[:notice] = "User successfully approved"
    else
      flash[:warning] = "Unable to approve user at the moment"
    end

    @users = User.all
    render :index
  end

  def admin_users
    @users.select { |u| current_tenant.is_admin?(u.email) }
  end

  def users_to_approve
    @users.select { |u| !u.approved}
  end

  def standard_users
    @users.select { |u| u.approved && !u.is_admin?}
  end
end
