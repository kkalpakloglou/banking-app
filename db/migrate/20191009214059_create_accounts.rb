class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :number, index: true, unique: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
