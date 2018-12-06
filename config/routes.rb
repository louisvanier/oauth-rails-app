Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }, skip: [:session]

  devise_scope :user do
    delete '/sign_out' => 'devise/sessions#destroy', as: :destroy_user_session
    get 'users/login', to: 'devise/sessions#new'
    post 'users/login', to: 'devise/sessions#create'
  end

  get 'users/index'
  match 'users/delete/:id', to: 'users#delete', via: [:delete]
  match 'users/approve/:id', to: 'users#approve', via: [:patch]
  get 'revenue_shares/index'
  get 'revenue_shares/new'
  root 'users#login'
end
