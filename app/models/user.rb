class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :registerable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2, :facebook]

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    unless user
      user = User.create(name: data['name'],
        email: data['email'],
        password: Devise.friendly_token[0,20],
        provider: access_token.provider,
        uid: access_token.uid,
      )
    end
    user
  end

  def active_for_authentication?
    super && approved
  end

  def inactive_message
    approved ? nil : :not_approved
  end
end
