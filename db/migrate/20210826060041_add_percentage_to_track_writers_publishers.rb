class AddPercentageToTrackWritersPublishers < ActiveRecord::Migration[6.1]
  def change
    add_column :track_writers, :percentage, :integer, default: 0
    add_column :track_publishers, :percentage, :integer, default: 0
  end
end
