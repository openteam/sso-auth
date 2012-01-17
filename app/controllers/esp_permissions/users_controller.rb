class EspPermissions::UsersController < EspPermissions::ApplicationController
  has_searcher
  actions :index
  has_scope :page, :default => 1

  protected

    def collection
      get_collection_ivar || set_collection_ivar(search_and_paginate_collection)
    end

    def search_and_paginate_collection
      if params[:utf8]
        search_object = searcher_for(resource_instance_name)
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
