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
  validate :sufficient_balance, on: :create

  # Callbacks
  before_validation :generate_code, on: [:create]
  after_create :update_balance

  private

  def sufficient_balance
    errors.add :base, :insufficient_balance if transaction_type == "debit" && account.balance < amount
  end

  def update_balance
    self.updated_balance = account.balance
    self.save!
  end

  def generate_code
    self.code ||= loop do
      random_code = SecureRandom.hex(8).upcase
      break random_code unless Transaction.exists?(code: random_code)
    end
  end
end
