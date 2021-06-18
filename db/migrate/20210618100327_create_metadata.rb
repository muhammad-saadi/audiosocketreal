class CreateMetadata < ActiveRecord::Migration[6.1]
  def change
    create_table :metadata do |t|
      t.string :key
      t.text :content
    end
  end
end
