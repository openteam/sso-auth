class EspAuth::ApplicationController < EspAuth::ManageController
  before_filter :authorize_user_can_manage_permissions!

  inherit_resources

  protected

    def authorize_user_can_manage_permissions!
      authorize! :manage, :permissions
    end
end
