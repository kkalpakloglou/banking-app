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
    Money.new(transactions.credit.sum(:amount_cents) - transactions.debit.sum(:amount_cents))
  end

  private

  def generate_number
    self.number ||= loop do
      random_number = SecureRandom.hex(8).upcase
      break random_number unless Account.exists?(number: random_number)
    end
  end
end
