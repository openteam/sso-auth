class EspPermissions::ApplicationController < ApplicationController
  inherit_resources
  before_filter :authenticate_user!
end
