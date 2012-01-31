Rails.application.routes.draw do
  namespace :manage do
    root :to => 'application#index'
  end
  mount EspAuth::Engine => "/auth"
  root :to => 'application#index'
end
