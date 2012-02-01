require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../dummy/config/environment", __FILE__)
  require 'rspec/rails'
  require 'cancan/matchers'
  require 'shoulda/matchers'
  require 'sunspot_matchers'
  require 'fabrication'

  SPEC_ROOT = Rails.root.join('..').to_s

  Dir["#{SPEC_ROOT}/fabricators/**/*.rb"].each {|f| require f}
  require "#{SPEC_ROOT}/../lib/esp_auth/spec_helper"

  RSpec.configure do |config|
   config.use_transactional_fixtures = true
   config.include EspAuth::SpecHelper
   config.before(:all) do
     Sunspot.session = SunspotMatchers::SunspotSessionSpy.new(Sunspot.session)
   end
  end

  Spork.each_run do
    ActiveSupport::Dependencies.clear
    Rails.application.reload_routes!
  end

end
