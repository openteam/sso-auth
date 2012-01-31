Rails.application.routes.draw do
  namespace :manage do
    root :to => 'application#index'
  end
  root :to => 'application#index'
end
