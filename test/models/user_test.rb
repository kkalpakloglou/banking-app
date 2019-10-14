require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'that_an_account_is_opened_after_a_user_is_registered' do
    new_user = User.create(first_name: 'Test', last_name: 'User', email: 'test_user@test.gr', password: 'testing')

    assert new_user.accounts.exists?
  end
end
