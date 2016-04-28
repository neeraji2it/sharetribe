# == Schema Information
#
# Table name: emails
#
#  id                   :integer          not null, primary key
#  person_id            :string(255)
#  address              :string(255)
#  confirmed_at         :datetime
#  confirmation_sent_at :datetime
#  confirmation_token   :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  send_notifications   :boolean
#
# Indexes
#
#  index_emails_on_address    (address) UNIQUE
#  index_emails_on_person_id  (person_id)
#

class Email < ActiveRecord::Base

  # TODO Rails 4, Remove
  include ActiveModel::ForbiddenAttributesProtection

  include ApplicationHelper
  belongs_to :person

  validates_presence_of :person
  validates_uniqueness_of :address
  validates_length_of :address, :maximum => 255
  validates_format_of :address,
                       :with => /\A[A-Z0-9._%\-\+\~\/]+@([A-Z0-9-]+\.)+[A-Z]+\z/i

  before_save do
    #force email to be lower case
    self.address = self.address.downcase
    if not confirmed_at
      self.confirmation_token ||= SecureRandom.base64(12)
    end
  end

  def confirm!
    self.confirmed_at = Time.now
    self.save
  end

  # Email already in use for current user or someone else
  def self.email_available?(email)
    !Email.find_by_address(email).present?
  end

  # Email already in use for someone else than current user
  def self.email_available_for_user?(user, address)
    email = Email.find_by_address(address)
    !email.present? || email.person == user
  end

  def self.send_confirmation(email, community)
    MailCarrier.deliver_later(PersonMailer.email_confirmation(email, community))
  end

  def self.find_by_address_and_community_id(address, community_id)
    Email
      .joins("INNER JOIN community_memberships ON community_memberships.person_id = emails.person_id")
      .find_by(address: address, community_memberships: { community_id: community_id })
  end
end