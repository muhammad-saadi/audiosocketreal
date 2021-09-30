class Folder < ApplicationRecord
  belongs_to :consumer
  belongs_to :parent_folder, class_name: "Folder", optional: true
  has_many :sub_folders, class_name: "Folder", foreign_key: "parent_folder_id", dependent: :destroy
  has_many :consumer_playlists, dependent: :destroy
end
