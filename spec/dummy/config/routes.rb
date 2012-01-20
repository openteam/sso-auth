Rails.application.routes.draw do
  namespace :manage do
    mount EspPermissions::Engine => "/permissions"
  end
  root :to => 'application#index'
end
