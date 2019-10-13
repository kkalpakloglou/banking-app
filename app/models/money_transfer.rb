class MoneyTransfer < ApplicationRecord
  include WithMoneyColumn

  # money attributes
  monetize :amount_cents, DEFAULT_MONEY_COLUMN_OPTIONS

  attr_accessor :account_number

  # Associations
  belongs_to :sender, class_name: 'Account', foreign_key: 'sender_id'
  belongs_to :receiver, class_name: 'Account', foreign_key: 'receiver_id'
  has_many :transactions

  # Validations
  validates :sender_id, :receiver_id, :amount_cents, :amount_currency, presence: true
  validates :amount_cents, numericality: { greater_than: 0 }
  validate  :receiver_is_different_than_sender
  validate  :sufficient_balance, on: :create

  private

  def sufficient_balance
    errors.add :base, :insufficient_balance if sender.balance < amount
  end

  def receiver_is_different_than_sender
    errors.add :base, :receiver_is_not_different_than_sender if sender_id == receiver_id
  end
end
