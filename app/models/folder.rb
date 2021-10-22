class Folder < ApplicationRecord
  belongs_to :consumer
  belongs_to :parent_folder, class_name: 'Folder', optional: true

  has_many :consumer_playlists, dependent: :destroy
  has_many :sub_folders, class_name: 'Folder', foreign_key: 'parent_folder_id', dependent: :destroy

  validate :same_consumer

  before_validation :set_level, :level_validation

  MAX_LEVEL_ALLOWED = 1

  def self.sub_folder_hash(consumer)
    eagerload_columns = {}
    current_level = eagerload_columns
    max_level = consumer.folders.maximum('level') + 1

    max_level.times.each do
      current_level[:sub_folders] = consumer_playlist_hash
      current_level = current_level[:sub_folders]
    end

    eagerload_columns
  end

  def self.consumer_playlist_hash
    { consumer_playlists: [banner_image_attachment: :blob, playlist_image_attachment: :blob, tracks: [:alternate_versions, filters: [:parent_filter, sub_filters: [sub_filters: :sub_filters]], file_attachment: :blob]] }
  end

  def self.eagerload_cols(consumer)
    [
      sub_folder_hash(consumer),
      consumer_playlist_hash
    ]
  end

  def same_consumer
    return if parent_folder_id.blank?

    errors.add(:parent_folder, 'is invalid') if consumer.id != parent_folder&.consumer_id
  end

  def set_level
    return if parent_folder.blank?

    self.level = parent_folder.level + 1
  end

  def level_validation
    errors.add(:parent_folder, 'Folder limit reached') if level > MAX_LEVEL_ALLOWED
  end
end
