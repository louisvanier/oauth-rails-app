class UsersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound do |_|
    head :not_found
  end

  before_action :authenticate_user!, except: :login

  helper_method  :admin_users, :users_to_approve, :standard_users

  def login
    Rails.logger.info("#{session}")
    render :login, layout: 'layouts/login'
  end

  def index
    unless is_admin?
      Rails.logger.info("[UNAUTHORIZED] non-admin user hitting #index endpoint")
      return head :unauthorized
    end
    @users = User.all.where(discarded_at: nil)
  end

  def delete
    unless is_admin?
      Rails.logger.info("[UNAUTHORIZED] non-admin user hitting #delete endpoint")
      return head :unauthorized
    end

    if user.approved ? user.discard : user.destroy
      flash[:notice] = "User #{user.email} successfully deleted"
    else
      flash[:warning] = "failure to delete #{user.email}"
    end

    redirect_to users_manage_url
  end

  def update
    unless is_admin?
      Rails.logger.info("[UNAUTHORIZED] non-admin user hitting #approve endpoint")
      return head :unauthorized
    end

    if user.update_attributes(share_percentage: update_params[:share_percentage])
      flash[:notice] = "Share percentage updated"
    else
      flash[:warning] = "Unable to update user at the moment"
    end

    redirect_to users_manage_url
  end

  def approve
    unless is_admin?
      Rails.logger.info("[UNAUTHORIZED] non-admin user hitting #approve endpoint")
      return head :unauthorized
    end

    if user.update_attributes(approved: true, share_percentage: update_params[:share_percentage])
      flash[:notice] = "User successfully approved"
    else
      flash[:warning] = "Unable to approve user at the moment"
    end

    @users = User.all
    redirect_to users_manage_url
  end

  private

  def update_params
    params.require(:user).permit(:id, :share_percentage)
  end

  def user
    @user ||= User.find_by!(id: params.permit(:id)[:id])
  end

  def admin_users
    @users.select { |u| current_tenant.is_admin?(u.email) }.sort_by(&:name)
  end

  def users_to_approve
    @users.select { |u| !u.approved}.sort_by(&:name)
  end

  def standard_users
    @users.select { |u| u.approved && !current_tenant.is_admin?(u.email)}.sort_by(&:name)
  end
end
