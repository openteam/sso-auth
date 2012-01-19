EspPermissions::Engine.routes.draw do
  resources :permissions, :only => [:new, :create, :destroy]

  resources :users, :only => :index do
    resources :permissions, :only => [:new, :create, :destroy]
  end

  match '/users/search' => "users#search"

  root :to => 'users#index'
end
