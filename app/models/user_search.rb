class UserSearch < Search
  column :term, :text
  column :permissions_count_gt, :integer
end

# == Schema Information
#
# Table name: searches
#
#  keywords :text
#

