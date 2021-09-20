class AddDeletableToFolder < ActiveRecord::Migration[6.1]
  def change
    add_column :folders, :deletable, :boolean, default: :true
  end
end
