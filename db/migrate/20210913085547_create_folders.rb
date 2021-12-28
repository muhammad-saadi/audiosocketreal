class CreateFolders < ActiveRecord::Migration[6.1]
  def change
    create_table :folders do |t|
      t.string :name
      t.references :consumer
      t.references :parent_folder
      t.integer :level, default: 0

      t.timestamps
    end
  end
end
