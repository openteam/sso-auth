# Configure Rails Environment
ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../dummy/config/environment',  __FILE__)
require 'rspec/rails'

require 'cancan/matchers'
require 'shoulda/matchers'

require File.expand_path('../../lib/sso-auth/spec_helper', __FILE__)

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.include SsoAuth::SpecHelper
end
