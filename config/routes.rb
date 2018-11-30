Rails.application.routes.draw do
  get 'users/login'
  get 'users/index'
  get 'revenue_shares/index'
  get 'revenue_shares/new'
  root to: 'home#index'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
end
