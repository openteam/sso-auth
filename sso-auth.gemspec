$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'sso_auth/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'sso-auth'
  s.version     = SsoAuth::VERSION
  s.authors     = ['http://openteam.ru']
  s.email       = ['mail@openteam.ru']
  s.summary     = 'Summary of SsoAuth.'
  s.description = 'Description of SsoAuth.'

  s.files = Dir['{app,config,db,lib}/**/*'] + ['MIT-LICENSE', 'Rakefile', 'README.rdoc']

  s.add_dependency 'cancan'
  s.add_dependency 'configliere'
  s.add_dependency 'devise'
  s.add_dependency 'omniauth'
  s.add_dependency 'omniauth-oauth2'

  s.add_development_dependency 'debugger'
  s.add_development_dependency 'rails'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'sqlite3'
end
