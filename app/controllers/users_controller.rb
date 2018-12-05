class UsersController < ApplicationController
  before_action :authenticate_user!, except: :login
  def login
    Rails.logger.info("#{session}")
    @user = current_user
    render :login, layout: 'layouts/login'
  end

  def index
    return :unauthorized unless is_admin?
    @users = User.all
    render :index
  end
end
