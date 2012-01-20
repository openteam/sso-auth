$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'esp-permissions/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'esp-permissions'
  s.version     = EspPermissions::VERSION
  s.authors     = ['http://openteam.ru']
  s.email       = ['mail@openteam.ru']
  s.summary     = 'Summary of EspPermissions.'
  s.description = 'Description of EspPermissions.'

  s.files = Dir['{app,config,db,lib}/**/*'] + ['MIT-LICENSE', 'Rakefile', 'README.rdoc']

  s.add_dependency 'ancestry'
  s.add_dependency 'cancan'
  s.add_dependency 'compass', '>= 0.12.alpha.2'
  s.add_dependency 'curb'
  s.add_dependency 'formtastic'
  s.add_dependency 'has_enum'
  s.add_dependency 'has_searcher'
  s.add_dependency 'inherited_resources'
  s.add_dependency 'kaminari'
  s.add_dependency 'progress_bar'
  s.add_dependency 'rails'
  s.add_dependency 'sass'
  s.add_dependency 'sass-rails'
  s.add_dependency 'sso_client'
  s.add_dependency 'spork', '>= 0.9.0.rc9'
  s.add_dependency 'sunspot_rails'

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-spork'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'sunspot_solr'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'forgery'
  s.add_development_dependency 'ryba'
  s.add_development_dependency 'fabrication'
  s.add_development_dependency 'therubyracer'
  s.add_development_dependency 'uglifier'
end
