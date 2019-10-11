class User < ApplicationRecord
  devise :database_authenticatable, :validatable

  # Associations
  has_many :accounts

  # Validations
  validates :first_name, :last_name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  # Callbacks
  after_create :create_account

  private

  def create_account
    accounts.create unless accounts.exists?
  end
end
