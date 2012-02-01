class EspAuth::ManageController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_user_can_manage_application!

  protected

    def authorize_user_can_manage_application!
      authorize! :manage, :application
    end
end
