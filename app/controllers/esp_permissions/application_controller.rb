class EspPermissions::ApplicationController < ApplicationController
  inherit_resources
  before_filter :authenticate_user!
  before_filter :authorize_user!

  protected

    def authorize_user!
      authorize! :create, Permission.new
    end
end
