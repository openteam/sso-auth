Rails.application.routes.draw do
  devise_for :users, :path => 'auth',
                     :controllers => {:omniauth_callbacks => 'sso_auth/omniauth_callbacks'},
                     :skip => [:sessions]

  devise_scope :users do
    get 'sign_out' => 'sso-auth/sessions#destroy', :as => :destroy_user_session
    get 'sign_in' => redirect('/auth/auth/identity'), :as => :new_user_session
  end
end

