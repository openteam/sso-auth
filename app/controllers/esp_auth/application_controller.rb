class EspAuth::ApplicationController < ApplicationController
  esp_load_and_authorize_resource

  before_filter :authorize_user_can_manage_permissions!

  protected

    def authorize_user_can_manage_permissions!
      authorize! :manage, :permissions
    end
end
