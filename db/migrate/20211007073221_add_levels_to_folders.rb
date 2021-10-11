class AddLevelsToFolders < ActiveRecord::Migration[6.1]
  def change
    add_column :folders, :max_levels_allowed, :integer, default: 0
  end
end
