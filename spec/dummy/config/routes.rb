Rails.application.routes.draw do
  namespace :manage do
    mount EspPermissions::Engine => "/permissions"
    root :to => 'application#index'
  end
  root :to => 'application#index'
end
