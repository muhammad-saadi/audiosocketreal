class AddImagesStatus < ActiveRecord::Migration[6.1]
  def change
    add_column :artist_profiles, :banner_image_status, :string, default: 'rejected'
    add_column :artist_profiles, :cover_image_status, :string, default: 'rejected'
  end
end
