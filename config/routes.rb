EspAuth::Engine.routes.draw do
  resources :permissions, :only => [:new, :create, :destroy]

  resources :users, :only => :index do
    resources :permissions, :only => [:new, :create, :destroy]
  end

  match '/users/search' => "users#search"

  get 'sign_out' => 'sessions#destroy', :as => :destroy_user_session

end

Rails.application.routes.draw do
  devise_for :users, :path => 'auth', controllers: {omniauth_callbacks:'esp_auth/omniauth_callbacks'}, :skip => [:sessions]

  devise_scope :users do
    get 'sign_in' => redirect('/auth/auth/identity'), :as => :new_user_session
  end

  mount EspAuth::Engine => '/auth'

end rescue NameError

