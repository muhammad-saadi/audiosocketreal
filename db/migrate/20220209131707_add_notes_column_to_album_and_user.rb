class AddNotesColumnToAlbumAndUser < ActiveRecord::Migration[6.1]
  def change
    add_column :albums, :admin_note, :text
    add_column :users, :admin_note, :text
  end
end
