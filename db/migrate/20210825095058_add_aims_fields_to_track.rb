class AddAimsFieldsToTrack < ActiveRecord::Migration[6.1]
  def change
    add_column :tracks, :aims_id, :string
    add_column :tracks, :aims_status, :string
  end
end
