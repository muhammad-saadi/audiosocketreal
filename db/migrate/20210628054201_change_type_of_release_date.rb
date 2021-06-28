class ChangeTypeOfReleaseDate < ActiveRecord::Migration[6.1]
  def up
    change_column :albums, :release_date, :date
  end

  def down
    change_column :albums, :release_date, :datetime
  end
end
