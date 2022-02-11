class AddDefaultExplicitToTracks < ActiveRecord::Migration[6.1]
  def change
    change_column :tracks, :explicit, :boolean, default: false
    change_column :tracks, :public_domain, :boolean, default: true
    change_column :tracks, :instrumental, :boolean, default: false
  end
end
