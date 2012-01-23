class EspPermissions::UsersController < EspPermissions::ApplicationController
  has_searcher

  actions :index, :new, :create, :destroy, :search

  has_scope :with_permissions, :default => 1
  has_scope :page, :default => 1

  def search
    render :json => JSON.parse(Curl::Easy.http_get("#{Settings['sso.url']}/users.json?user_search[keywords]=#{URI.escape(params[:term])}").body_str) and return
  end

  protected
    def collection
      get_collection_ivar || set_collection_ivar(search_and_paginate_collection)
    end

    def search_and_paginate_collection
      if params[:utf8]
        search_object = searcher_for(resource_instance_name)
        search_object.permissions_count_gt = 1
        search_object.pagination = paginate_options
        search_object.results
      else
        end_of_association_chain.per(per_page)
      end
    end

    def paginate_options(options={})
      {
        :page       => params[:page],
        :per_page   => per_page
      }.merge(options)
    end

    def per_page
      10
    end
end
