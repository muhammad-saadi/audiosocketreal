class ChangeBpmToInteger < ActiveRecord::Migration[6.1]
  def change
    remove_column :tracks, :bpm, :string
    add_column :tracks, :bpm, :integer
  end
end
