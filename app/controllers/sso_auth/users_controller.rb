require 'open-uri'

class SsoAuth::UsersController < ApplicationController
  respond_to :json

  def index
    authorize! :manage, :permissions
    response = open("#{Settings['sso.url']}/users.json?user_search[keywords]=#{URI.escape(params[:term])}")
    render :json => JSON.parse(response.read)
  end
end
