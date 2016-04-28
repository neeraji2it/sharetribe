# == Schema Information
#
# Table name: orders
#
#  id               :integer          not null, primary key
#  firstname        :string(255)
#  lastname         :string(255)
#  email            :string(255)
#  cardtype         :string(255)
#  cardno           :string(255)
#  username         :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  express_token    :string(255)
#  express_payer_id :string(255)
#  card_expires_on  :date

#  phone_no         :string(255)
#  listing_id       :integer

#

require 'rails_helper'

RSpec.describe Order, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
