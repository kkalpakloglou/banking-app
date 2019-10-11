# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :first_name,         null: false, default: ""
      t.string :last_name,          null: false, default: ""
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      t.timestamps null: false
    end
    add_index :users, :first_name
    add_index :users, :last_name
    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
  end
end
