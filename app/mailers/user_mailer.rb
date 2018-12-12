class UserMailer < ApplicationMailer
  default from: 'notifications@tehg4m3.com'

  def new_user_created
    tenant = params[:tenant]
    @new_user = params[:user]
    @user_index_url = params[:user_index_url]
    mail(to: tenant.admins.join(','), subject: "[#{tenant.subdomain}] A new user has registered: #{new_user.name}")
  end
end
