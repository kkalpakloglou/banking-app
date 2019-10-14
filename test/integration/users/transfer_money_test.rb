require 'test_helper'

class TransferMoneyTest < ActionDispatch::IntegrationTest
  def setup
    @user     = users(:default)
    @sender   = accounts(:default)
    @receiver = accounts(:receiver)
  end

  test 'should redirect to login page, if user is not logged in' do
    get new_money_transfer_path(sender_id: @sender.id)

    assert_equal 302, status
  end

  test 'should raise ArguementError if no account is specified' do
    sign_in(@user)

    assert_raises ArgumentError do
      get new_money_transfer_path
    end
  end

  test 'should create a new money tranfer object and two new transactions' do
    sign_in(@user)
    
    current_money_transfers = MoneyTransfer.count
    sender_debit_transactions = @sender.transactions.debit.count
    receiver_credit_transactions = @receiver.transactions.credit.count

    post money_transfers_path, params: { 
      money_transfer: { 
        sender_id: @sender.id,
        account_number: @receiver.number,
        amount: 1,
        description: "test"
      }
    }

    assert_equal current_money_transfers + 1, MoneyTransfer.count
    assert_equal sender_debit_transactions + 1, @sender.transactions.debit.count
    assert_equal receiver_credit_transactions + 1, @receiver.transactions.credit.count
  end

  test 'should redirect to transactions, if money was tranferred successfully' do
    sign_in(@user)

    post money_transfers_path, params: { 
      money_transfer: { 
        sender_id: @sender.id,
        account_number: @receiver.number,
        amount: 1,
        description: "test"
      }
    }
    
    assert_redirected_to transactions_account_url(@sender)
  end
  
  test 'render new and display flash error message, if money was tranferred' do
    sign_in(@user)

    post money_transfers_path, params: { 
      money_transfer: { 
        sender_id: @sender.id,
        account_number: @sender.number,
        amount: 0,
        description: "test"
      }
    }

    assert_equal 200, status
    assert_not_nil flash[:error]
  end
end
