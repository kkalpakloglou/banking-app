class MoneyTransfersController < ApplicationController
  before_action :authenticate_user!, :set_sender

  def new
    @money_transfer = MoneyTransfer.new sender_id: @sender.id
  end

  def create
    @money_transfer = MoneyTransfer.new permitted_params

    @receiver = Account.find_by number: permitted_params[:account_number]
    @money_transfer.receiver_id = @receiver.try(:id)

    if @money_transfer.valid?
      begin
        MoneyTransfer.transaction do
          @money_transfer.save!
          
          @sender.transactions.debit.create!(amount: @money_transfer.amount, money_transfer_id: @money_transfer.id)
          @receiver.transactions.credit.create!(amount: @money_transfer.amount, money_transfer_id: @money_transfer.id)

          flash[:notice] = 'Money transferred successfully!'
          redirect_to transactions_account_path(@sender)
        end
      rescue ActiveRecord::RecordInvalid
        flash.now[:error] = 'Make sure you have sufficient fund in your account.'
        render :new
      end
    else
      flash.now[:error] = @money_transfer.errors.full_messages.to_sentence
      render :new
    end
  end

  private
  def set_sender
    @sender = current_user.accounts.find (params[:sender_id] || permitted_params[:sender_id])
  end

  def permitted_params
    params.require(:money_transfer).permit(:sender_id, :account_number, :amount, :description)
  end
end
