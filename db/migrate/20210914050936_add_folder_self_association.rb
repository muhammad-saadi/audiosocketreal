class AddFolderSelfAssociation < ActiveRecord::Migration[6.1]
  def change
    add_reference :folders, :parent_folder, foreign_key: { to_table: :folders }
  end
end
