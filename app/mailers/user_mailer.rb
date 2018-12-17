class UserMailer < ApplicationMailer
  default from: 'notifications@tehg4m3.com'

  def new_user_created
    tenant = params[:tenant]
    Apartment::Tenant.switch(tenant.subdomain) do
      @new_user = User.find_by(id: params[:user_id])
      @user_index_url = params[:user_index_url]
      mail(to: tenant.admins.join(','), subject: "[#{tenant.subdomain}] A new user has registered: #{new_user.name}")
    end
  end
end
