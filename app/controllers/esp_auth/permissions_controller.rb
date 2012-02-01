class EspAuth::PermissionsController < EspAuth::ApplicationController
  belongs_to :user, :optional => true
  actions :new, :create, :destroy

  helper_method :available_contexts

  def create
    create!{ esp_auth.users_path }
  end

  def destroy
    destroy!{ esp_auth.users_path }
  end

  protected

    def available_contexts
      @available_contexts ||= Context.available_for(current_user)
    end
end
