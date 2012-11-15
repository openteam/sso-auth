class SsoAuth::SessionsController < ApplicationController
  def destroy
    reset_session
    redirect_to "#{Settings['sso.url']}/users/sign_out?redirect_uri=#{CGI.escape(redirect_uri)}"
  end

  protected

    def redirect_uri
      URI.parse(request.url).tap do | uri |
        uri.path = main_app.root_path
        uri.query = nil
      end.to_s
    end

end
