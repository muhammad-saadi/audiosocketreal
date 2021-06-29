class RenameCoverImageStatusToProfileImageStatus < ActiveRecord::Migration[6.1]
  def change
    rename_column :artist_profiles, :cover_image_status, :profile_image_status
  end
end
