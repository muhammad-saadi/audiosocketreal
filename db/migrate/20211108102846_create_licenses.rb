class CreateLicenses < ActiveRecord::Migration[6.1]
  def change
    create_table :licenses do |t|
      t.string :name
      t.text :description
      t.text :license_html
      t.float :price
      
      t.timestamps
    end
  end
end
