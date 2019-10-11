class MoneyTransfer < ApplicationRecord
  include WithMoneyColumn

  # money attributes
  monetize :amount_cents, DEFAULT_MONEY_COLUMN_OPTIONS

  attr_accessor :account_number

  # Associations
  belongs_to :account, class_name: 'Account', foreign_key: 'sender_id'
  belongs_to :account, class_name: 'Account', foreign_key: 'receiver_id'
  has_many :transactions

  # Validations
  validates :sender_id, :receiver_id, :amount_cents, :amount_currency, presence: true
  validate  :receiver_is_different_than_sender

  private

  def receiver_is_different_than_sender
    errors.add :base, :receiver_is_not_different_than_sender if sender_id == receiver_id
  end
end
