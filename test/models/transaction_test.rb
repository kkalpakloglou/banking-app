require 'test_helper'

class TransactionTest < ActiveSupport::TestCase
  def setup
    @account = accounts(:default)
  end

  test 'that transaction code is generated on create, properly' do
    new_transaction = Transaction.create(account: @account, amount: 1000)

    assert_not_nil new_transaction.code
  end

  test 'that informative updated_balance field does refresh' do
    current_balance = @account.balance.cents
    amount_to_credit = 1000

    Transaction.transaction do
      Transaction.create(account: @account, amount_cents: amount_to_credit)
      assert_equal @account.balance.cents, current_balance + amount_to_credit

      raise ActiveRecord::Rollback
    end
  end
end
