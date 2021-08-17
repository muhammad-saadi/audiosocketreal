class ChangeFieldsToText < ActiveRecord::Migration[6.1]
  def up
    change_column :tracks, :description, :text
    change_column :tracks, :admin_note, :text
  end

  def down
    change_column :tracks, :description, :string
    change_column :tracks, :admin_note, :string
  end
end
