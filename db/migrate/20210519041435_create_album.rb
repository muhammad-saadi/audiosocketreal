class CreateAlbum < ActiveRecord::Migration[6.1]
  def change
    create_table :albums do |t|
      t.string :name
      t.datetime :release_date

      t.references :user

      t.timestamps
    end
  end
end
