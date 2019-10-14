class Transaction < ApplicationRecord
  include WithMoneyColumn

  enum transaction_type: { credit: 0, debit: 1 }

  # money attributes
  monetize :amount_cents, :updated_balance_cents, DEFAULT_MONEY_COLUMN_OPTIONS

  # Associations
  belongs_to :account
  belongs_to :money_transfer, optional: true

  # Validations
  validates :account_id, :amount_cents, :amount_currency, :transaction_type, presence: true

  # Callbacks
  before_validation :set_transaction_code, on: [:create]
  after_create :update_balance

  private

  def update_balance
    Transaction.unscoped { update_attribute(:updated_balance, account.balance) }
  end

  def set_transaction_code
    self.code ||= GenerateRandomCodeService.perform(self.class, :code)
  end
end
