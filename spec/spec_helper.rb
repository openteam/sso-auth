require 'rubygems'

ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../dummy/config/environment", __FILE__)
require 'rspec/rails'
require 'cancan/matchers'
require 'shoulda/matchers'

SPEC_ROOT = Rails.root.join('..').to_s

Dir["#{SPEC_ROOT}/fabricators/**/*.rb"].each {|f| require f}
require "#{SPEC_ROOT}/../lib/sso_auth/spec_helper"

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.include SsoAuth::SpecHelper
end
