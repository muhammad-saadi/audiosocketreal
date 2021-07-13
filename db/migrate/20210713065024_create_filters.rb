class CreateFilters < ActiveRecord::Migration[6.1]
  def change
    create_table :filters do |t|
      t.string :name
      t.integer :max_levels_allowed

      t.references :filter
      t.timestamps
    end
  end
end
