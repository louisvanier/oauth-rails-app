class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2, :facebook]

  def self.from_omniauth(omniauth_data, approved)
    user = User.where(email: omniauth_data['email']).first

    unless user
      user = User.create(name: omniauth_data['name'],
        email: omniauth_data['email'],
        password: Devise.friendly_token[0,20],
        provider: omniauth_data.provider,
        uid: omniauth_data.uid,
        image_url: omniauth_data['image'],
        approved: approved,
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
