SsoAuth::Engine.routes.draw do
  resources :users, :only => :index
  get 'sign_out' => 'sessions#destroy', :as => :destroy_user_session
end

Rails.application.routes.draw do
  devise_for :users, :path => 'auth',
                     :controllers => {:omniauth_callbacks => 'sso_auth/omniauth_callbacks'},
                     :skip => [:sessions]

  devise_scope :users do
    get 'sign_in' => redirect('/auth/auth/identity'), :as => :new_user_session
  end

  mount SsoAuth::Engine => '/auth'
end

