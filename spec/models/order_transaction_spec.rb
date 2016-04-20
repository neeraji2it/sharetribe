# == Schema Information
#
# Table name: order_transactions
#
#  id            :integer          not null, primary key
#  order_id      :integer
#  action        :string(255)
#  amount        :integer
#  success       :boolean
#  authorization :string(255)
#  message       :string(255)
#  params        :text(65535)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe OrderTransaction, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
