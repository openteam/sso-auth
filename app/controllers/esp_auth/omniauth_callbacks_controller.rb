class EspAuth::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def identity
    User.find_or_initialize_by_uid(request.env['omniauth.auth']['uid']).tap do |user|
      user.update_attributes request.env['omniauth.auth']['info']
    end

    flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Identity"
    sign_in user, :event => :authentication
    redirect_to stored_location_for(:user) || main_app.root_path
  end
end
