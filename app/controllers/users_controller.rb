class UsersController < ApplicationController
  before_action :authenticate_user!, except: :login
  def login
    Rails.logger.info("#{session}")
    @user = current_user
    render :login, layout: 'layouts/login'
  end

  def index
  end
end
