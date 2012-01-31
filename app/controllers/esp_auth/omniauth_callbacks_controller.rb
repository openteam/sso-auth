class EspAuth::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def identity
    user = User.from_omniauth(request.env['omniauth.auth'])
    flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Identity"
    sign_in user, :event => :authentication
    redirect_to stored_location_for(:user) || main_app.root_path
  end
end
