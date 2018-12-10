Rails.application.routes.draw do
  resources :revenue_shares, only: [:index, :create, :update], format: :html do
    collection do
      get :prepare
    end
  end

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }, skip: [:session]

  devise_scope :user do
    get '/sign_in' => "users#login", as: :new_user_session
    delete '/sign_out' => 'devise/sessions#destroy', as: :destroy_user_session
    post 'users/login', to: 'devise/sessions#create', as: :user_session
  end

  resources :users, only: [] do
    member do
      delete :delete
      patch :approve
      patch :update
    end
  end

  match 'users/manage', to: 'users#index', via: [:get]

  match 'users/login', to: 'users#login', via: [:get]

  get 'revenue_shares/index'
  get 'revenue_shares/new'
  root 'users#login'
end
