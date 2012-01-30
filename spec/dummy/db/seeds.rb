# encoding: utf-8

User.find_or_initialize_by_uid('1').tap do | user |
  user.save(:validate => false)
  user.permissions.create! :context => Context.first, :role => :manager if user.permissions.empty?
end

Context.find(3).subcontexts.find_or_create_by_title('-------------------------')
