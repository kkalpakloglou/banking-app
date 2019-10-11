class AccountsController < ApplicationController
  before_action :authenticate_user!

  def index
    @accounts = current_user.accounts
  end

  def transactions
    @account = current_user.accounts.find params[:id]
    @transactions = @account.transactions.order(created_at: :desc).page(page).per(per)
  end

  private

  def page
    params[:page] || 1
  end

  def per
    params[:per] || 30
  end
end
