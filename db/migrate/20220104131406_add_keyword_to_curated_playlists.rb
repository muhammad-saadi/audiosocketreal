class AddKeywordToCuratedPlaylists < ActiveRecord::Migration[6.1]
  def change
    add_column :curated_playlists, :keywords, :text
  end
end
