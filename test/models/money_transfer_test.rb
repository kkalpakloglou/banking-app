require 'test_helper'

class MoneyTransferTest < ActiveSupport::TestCase
  def setup
    @sender = accounts(:default)
    @receiver = accounts(:receiver)
    @current_sender_balance = @sender.balance.cents
  end

  test 'that_an_error_is_raised_when_balance_is_insufficient' do
    new_money_transfer = MoneyTransfer.new(
      sender: @sender,
      receiver: @receiver,
      amount_cents: @current_sender_balance + 1
    )

    refute new_money_transfer.valid?
  end

  test 'that_a_user_cannot_transfer_money_within_the_same_account' do
    new_money_transfer = MoneyTransfer.new(
      sender: @sender,
      receiver: @sender,
      amount_cents: @current_sender_balance + 1
    )

    refute new_money_transfer.valid?
  end

  test 'a_valid_money_transfer' do
    Transaction.transaction do
      Transaction.create(account: @sender, amount_cents: 1000)

      new_money_transfer = MoneyTransfer.new(
        sender: @sender,
        receiver: @receiver,
        amount_cents: @sender.balance
      )

      assert new_money_transfer.save

      raise ActiveRecord::Rollback
    end
  end
end
