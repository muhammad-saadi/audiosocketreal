class RemoveDeletableFromFolders < ActiveRecord::Migration[6.1]
  def change
    remove_column :folders, :deletable, :boolean
  end
end
