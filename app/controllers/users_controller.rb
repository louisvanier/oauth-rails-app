class UsersController < ApplicationController
  before_action :authenticate_user!, except: :login

  helper_method  :admin_users, :users_to_approve, :standard_users

  def login
    Rails.logger.info("#{session}")
    @user = current_user
    render :login, layout: 'layouts/login'
  end

  def index
    unless is_admin?
      Rails.logger.info("[UNAUTHORIZED] non-admin user hitting #index endpoint")
      return :unauthorized
    end
    @users = User.all
    render :index
  end

  def delete
    unless is_admin?
      Rails.logger.info("[UNAUTHORIZED] non-admin user hitting #delete endpoint")
      return :unauthorized
    end
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
    unless is_admin?
      Rails.logger.info("[UNAUTHORIZED] non-admin user hitting #approve endpoint")
      return :unauthorized
    end

    user_to_approve = User.find_by!(id: params.permit(:id)[:id])
    if user_to_approve.update_attribute(:approved, true)
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
    @users.select { |u| u.approved && !current_tenant.is_admin?(u.email)}
  end
end
