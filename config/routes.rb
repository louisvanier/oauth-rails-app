Rails.application.routes.draw do
  get 'users/login'
  get 'users/index'
  get 'revenue_shares/index'
  get 'revenue_shares/new'
  root 'users#login'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :user do
    get 'sign_in', :to => 'users#login', as: :new_user_session
    post 'sign_in', to: 'devise/sessions#create', as: :user_session
    get 'sign_out', :to => 'devise/sessions#destroy', as: :destroy_user_session
  end
end
