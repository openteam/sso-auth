class EspPermissions::PermissionsController < EspPermissions::ApplicationController
  belongs_to :user, :shallow => true
  actions :new, :create, :destroy

  def create
    create!{ [:manage, :permissions, :users]}
  end

  def destroy
    destroy!{ [:manage, :permissions, :users] }
  end

end
