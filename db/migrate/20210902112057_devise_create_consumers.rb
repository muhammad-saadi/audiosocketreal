# frozen_string_literal: true

class DeviseCreateConsumers < ActiveRecord::Migration[6.1]
  def change
    create_table :consumers do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.string :first_name
      t.string :last_name
      t.string :content_type

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      t.timestamps null: false
    end

    add_index :consumers, :email,                unique: true
    add_index :consumers, :reset_password_token, unique: true
  end
end
