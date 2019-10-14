require 'test_helper'
require 'minitest/autorun'

class AccountTest < ActiveSupport::TestCase
  def setup
    @account = accounts(:default)
  end

  test 'that account number is generated on create, properly' do
    new_account = Account.new(user: users(:default))
    new_account.valid?

    assert_not_nil new_account.number
    assert new_account.save
  end

  test 'that balance returns money object' do
    assert_instance_of Money, @account.balance
  end

  test 'that balance is returned correctly' do
    @account.stub :sum_of_credit_in_cents, 1000 do
      @account.stub :sum_of_debit_in_cents, 100 do
        assert_equal @account.balance, Money.new(900)
      end
    end
  end

  test 'that balance is updated after a credit transaction' do
    current_balance = @account.balance.cents
    amount_to_credit = 1000

    Transaction.transaction do
      Transaction.create(account: @account, amount_cents: amount_to_credit)
      assert_equal @account.balance.cents, current_balance + amount_to_credit

      raise ActiveRecord::Rollback
    end
  end

  test 'that balance is updated after a debit transaction' do
    current_balance = @account.balance.cents
    amount_to_debit = 1000

    Transaction.transaction do
      Transaction.create(transaction_type: :debit, account: @account, amount_cents: amount_to_debit)
      assert_equal @account.balance.cents, current_balance - amount_to_debit

      raise ActiveRecord::Rollback
    end
  end
end
