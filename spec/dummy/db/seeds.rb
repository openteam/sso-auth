User.find_or_initialize_by_uid('1').tap do | user |
  user.save(:validate => false)
  user.permissions.create! :role => :manager if user.permissions.empty?
end
