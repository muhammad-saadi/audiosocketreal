class CreateLicenses < ActiveRecord::Migration[6.1]
  def change
    create_table :licenses do |t|
      t.string :name
      t.float :price
      t.text :description

      t.timestamps
    end
  end
end
