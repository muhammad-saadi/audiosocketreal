class CreateSubFilters < ActiveRecord::Migration[6.1]
  def change
    create_table :sub_filters do |t|
      t.string :name

      t.references :sub_filter
      t.references :filter
      t.timestamps
    end
  end
end
