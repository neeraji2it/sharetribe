# == Schema Information
#
# Table name: custom_field_option_selections
#
#  id                     :integer          not null, primary key
#  custom_field_value_id  :integer
#  custom_field_option_id :integer
#  listing_id             :integer
#  created_at             :datetime
#  updated_at             :datetime
#
# Indexes
#
#  index_custom_field_option_selections_on_custom_field_option_id  (custom_field_option_id)
#  index_custom_field_option_selections_on_custom_field_value_id   (custom_field_value_id)
#

class CustomFieldOptionSelection < ActiveRecord::Base
  belongs_to :custom_field_value
  belongs_to :custom_field_option
end
