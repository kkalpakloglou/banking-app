class CreateMoneyTransfers < ActiveRecord::Migration[5.2]
  def change
    create_table :money_transfers do |t|
      t.references :sender, foreign_key: { to_table: 'accounts' }
      t.references :receiver, foreign_key: { to_table: 'accounts' }
      t.monetize :amount, index: true, null: false
      t.string :description

      t.timestamps
    end
  end
end
