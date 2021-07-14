class CreateFilters < ActiveRecord::Migration[6.1]
  def change
    create_table :filters do |t|
      t.string :name
      t.integer :max_levels_allowed
      t.boolean :featured

      t.references :parent_filter
      t.timestamps
    end
  end
end
