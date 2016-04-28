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

class Order < ActiveRecord::Base
	#belongs_to :cart
  has_many :transactions, :class_name => "OrderTransaction"
  
  attr_accessor :card_number, :card_verification, :card_expires_on, :ip_address
  belongs_to :listing  
  #validate_on_create :validate_card
  
  def purchase
    response = STANDARD_GATEWAY.purchase(price_in_cents, credit_card, purchase_options)
    transactions.create!(:action => "purchase", :amount => price_in_cents, :response => response)
    response.success?
  end



  def price_in_cents
    self.listing.price_cents.to_i
  end

  private
  
  def purchase_options
    {
      :ip => ip_address,
      :billing_address => {
        :name     => "Ryan Bates",
        :address1 => "123 Main St.",
        :city     => "New York",
        :state    => "NY",
        :country  => "US",
        :zip      => "10001"
      }
    }
  end
  
  def validate_card
    unless credit_card.valid?
      credit_card.errors.full_messages.each do |message|
        errors.add_to_base message
      end
    end
  end
  
  def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
      :type               => cardtype,
      :number             => card_number,
      :verification_value => card_verification,
      :month              => card_expires_on.month,
      :year               => card_expires_on.year,
      :first_name         => firstname,
      :last_name          => lastname
    )
  end


end
