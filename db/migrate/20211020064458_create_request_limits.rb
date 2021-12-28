class CreateRequestLimits < ActiveRecord::Migration[6.1]
  def change
    create_table :request_limits do |t|
      t.integer :daily_usage
      t.date :last_used
      t.string :request_type
      t.references :limitable, polymorphic: true

      t.timestamps
    end
  end
end
