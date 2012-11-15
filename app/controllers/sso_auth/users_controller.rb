require 'open-uri'

class SsoAuth::UsersController < ApplicationController
  respond_to :json

  authorize! :manage, :permissions

  def index
    response = open("#{Settings['sso.url']}/users.json?user_search[keywords]=#{URI.escape(params[:term])}")
    render :json => JSON.parse(response.read)
  end
end
