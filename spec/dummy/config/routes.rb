Rails.application.routes.draw do

  mount EspPermissions::Engine => "/esp-permissions"
end
