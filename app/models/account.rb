class Account < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :transactions

  # Validations
  validates :number, presence: true, uniqueness: true
  validates :user_id, presence: true

  # Callbacks
  before_validation :generate_number, on: [:create]

  def balance
    Money.new(sum_of_credit_transactions - sum_of_debit_transactions)
  end

  private

  def sum_of_credit_transactions
    transactions.credit.sum(:amount_cents)
  end

  def sum_of_debit_transactions
    transactions.debit.sum(:amount_cents)
  end

  def generate_number
    self.number ||= loop do
      random_number = SecureRandom.hex(8).upcase
      break random_number unless Account.exists?(number: random_number)
    end
  end
end
