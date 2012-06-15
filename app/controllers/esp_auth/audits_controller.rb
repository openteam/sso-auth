class EspAuth::AuditsController < ApplicationController
  inherit_resources
  before_filter :authenticate_user!
  before_filter :authorize_user_can_view_audits!

  defaults :resource_class => Audited::Adapters::ActiveRecord::Audit

  has_scope :page, :default => 1

  layout 'esp_auth/application'

  protected
    def authorize_user_can_view_audits!
      render :file => "#{Rails.root}/public/403", :formats => [:html], :status => 403, :layout => false unless can?(:manage, Context.first)
    end

    def end_of_association_chain
      apply_scopes(resource_class.unscoped.order('id desc')).per(20)
    end
end
