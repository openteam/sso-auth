class EspPermissions::PermissionsController < EspPermissions::ApplicationController
  belongs_to :user, :optional => true
  helper_method :available_contexts

  def create
    unless params[:user_id] && @user = User.find(params[:user_id])
      @user = User.find_or_initialize_by_uid(params[:permission][:user_uid]).tap do |user|
        user.update_attributes :first_name => params[:permission][:user_first_name],
                               :last_name => params[:permission][:user_last_name],
                               :email => params[:permission][:user_email]
      end
    end

    @permission = Permission.new(params[:permission].merge(:user_id => @user.id))

    if @permission.save
      redirect_to esp_permissions.users_path
    else
      unless params[:user_id]
        @user = nil
        @permission.user_id = nil if params[:permission][:user_search].blank?
      end

      @permission.valid?

      render :new
    end
  end

  protected

    def available_contexts
      @available_contexts ||= Context.available_for(current_user)
    end
end
