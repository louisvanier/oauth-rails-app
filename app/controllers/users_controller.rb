class UsersController < ApplicationController
  before_action only: [:index, :delete] do
    return :unauthorized unless is_admin?
  end
  before_action :authenticate_user!, except: :login
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
end
