# encoding: utf-8

require 'forgery'
require 'ryba'

Fabricator(:user) do
  uid                   { sequence(:user_uid) }
  email                 { Forgery(:internet).email_address }
  name                  { Ryba::Name.full_name }
end
