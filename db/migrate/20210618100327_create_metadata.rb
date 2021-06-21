class CreateMetadata < ActiveRecord::Migration[6.1]
  def change
    create_table :metadata do |t|
      t.string :key
      t.text :content

      t.index :key, unique: true
      t.timestamps
    end
  end
end
