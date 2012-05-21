class EspAuth::UsersController < EspAuth::ApplicationController
  has_searcher

  actions :index, :search

  has_scope :page, :default => 1

  def search
    url = "#{Settings['sso.url']}/users.json?user_search[keywords]=#{URI.escape(params[:term])}"
    render :json => JSON.parse(Requester.new(url).response_body) and return
  end

  protected
    def collection
      get_collection_ivar || set_collection_ivar(search_and_paginate_collection)
    end

    def search_and_paginate_collection
      search_object = searcher_for(resource_instance_name)
      search_object.permissions_count_gt = 1
      search_object.pagination = {:page => params[:page], :per_page => 10}
      search_object.order_by = 'uid' if search_object.term.blank?
      search_object.results
    end
end
