class AddErrorDetailsToTracks < ActiveRecord::Migration[6.1]
  def change
    add_column :tracks, :aims_error_details, :string
  end
end
