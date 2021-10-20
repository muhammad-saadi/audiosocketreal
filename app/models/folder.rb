class Folder < ApplicationRecord
  belongs_to :consumer
  belongs_to :parent_folder, class_name: "Folder", optional: true
  has_many :sub_folders, class_name: "Folder", foreign_key: "parent_folder_id", dependent: :destroy
  has_many :consumer_playlists, dependent: :destroy

  validate :set_folder, on: [:create, :update]
  validate :level

  before_create :set_level

  parent_folders_sum = 0

  def self.subfolder_hash
    arr = {}
    temp = arr
    max_level = Consumer.first.folders.maximum('max_levels_allowed')
    max_level.times.each do
      temp[:sub_folders] = consumer_playlist_hash
      temp = temp[:sub_folders]
    end
    arr
  end

  def self.consumer_playlist_hash
    { consumer_playlists: [ banner_image_attachment: :blob, playlist_image_attachment: :blob, tracks: [:alternate_versions, filters: [:parent_filter, sub_filters: [sub_filters: :sub_filters]], file_attachment: :blob]] }
  end

  def self.eagerload_cols
    [
      subfolder_hash,
      consumer_playlist_hash
    ]
  end

  def set_folder
    consumer.folders.find(parent_folder_id) if parent_folder_id.present?
  end

  def set_level
    self.max_levels_allowed = check_parent_folder(self)
  end

  def level
    errors.add(:parent_folder, 'Folder limit reached') if parent_folder.present? && parent_folder.max_levels_allowed > 0
  end
  
  def check_parent_folder(folder, parent_folders_sum = 0)
    return  parent_folders_sum if folder.parent_folder_id.blank?
    check_parent_folder(Folder.find(folder.parent_folder_id), parent_folders_sum + 1)
  end
end
