class TransactionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @accounts = current_user.accounts
  end
end
