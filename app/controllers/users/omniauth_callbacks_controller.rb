class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
      sign_in @user, event: :authentication
      redirect_to get_redirection_path(@user.email)
    else
      session['devise.google_data'] = request.env['omniauth.auth'].except(:extra)
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end

  def facebook
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Facebook' if is_navigational_format?
      sign_in @user, event: :authentication
      redirect_to get_redirection_path(@user.email)
    else
      session['devise.facebook_data'] = request.env['omniauth.auth'].except(:extra)
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end

  def failure
    Rails.logger.info("[OMNIAUTH_CALLBACK] failure to authenticate using omniauth")
    redirect_to root_path
  end

  private

  def get_redirection_path(user)
    if current_tenant.is_admin?(user)
      users_index_path
    else
      revenue_shares_new_path
    end
  end
end
