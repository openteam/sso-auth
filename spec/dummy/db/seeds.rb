user = User.find_or_initialize_by_uid('1')
user.save!
user.permissions.create! :context => Context.first, :role => :manager
