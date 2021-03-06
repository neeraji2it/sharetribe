# == Schema Information
#
# Table name: checkout_accounts
#
#  id                        :integer          not null, primary key
#  company_id_or_personal_id :string(255)
#  merchant_id               :string(255)      not null
#  merchant_key              :string(255)      not null
#  person_id                 :string(255)      not null
#  created_at                :datetime
#  updated_at                :datetime
#

class CheckoutAccount < ActiveRecord::Base
  attr_accessible :person_id, :merchant_id, :merchant_key, :company_id_or_personal_id
  belongs_to :person
end
