class AddPublishFieldToTrack < ActiveRecord::Migration[6.1]
  def change
    add_column :tracks, :publish_date, :datetime
  end
end
