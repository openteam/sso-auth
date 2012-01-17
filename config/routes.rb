EspPermissions::Engine.routes.draw do
  resources :users, :only => :index do
    resources :permissions, :only => [:new, :create, :destroy], :shallow => true
  end
  root :to => 'users#index'
end
