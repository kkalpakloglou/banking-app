class Account < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :transactions

  # Validations
  validates :number, presence: true, uniqueness: true
  validates :user_id, presence: true

  # Callbacks
  before_validation :set_account_number, on: [:create]

  def balance
    Money.new(sum_of_credit_in_cents - sum_of_debit_in_cents)
  end

  private
  def sum_of_credit_in_cents
    transactions.credit.sum(:amount_cents)
  end

  def sum_of_debit_in_cents
    transactions.debit.sum(:amount_cents)
  end

  def set_account_number
    self.number ||= GenerateRandomCodeService.perform(self.class, :number)
  end
end
