class EspAuth::PermissionsController < EspAuth::ApplicationController
  belongs_to :user, :optional => true
  actions :new, :create, :destroy

  def create
    create!{ esp_auth.users_path }
  end

  def destroy
    destroy!{ esp_auth.users_path }
  end

end
