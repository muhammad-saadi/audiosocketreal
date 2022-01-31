class AddDurationToSfxes < ActiveRecord::Migration[6.1]
  def change
    add_column :sfxes, :duration, :float
  end
end
