class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.integer :transaction_type, index: true, default: 0
      t.monetize :amount, index: true, null: false
      t.string  :code, index: true, unique: true
      t.references :account
      t.monetize :updated_balance, index: true, null: false
      t.references :money_transfer

      t.timestamps
    end
  end
end