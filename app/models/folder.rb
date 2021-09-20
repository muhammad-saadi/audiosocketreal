class Folder < ApplicationRecord
  belongs_to :consumer, optional: true
  belongs_to :parent_folder, class_name: "Folder", optional: true
  has_many :sub_folders, class_name: "Folder", foreign_key: "parent_folder_id"
  has_many :consumer_playlists, dependent: :destroy

  before_destroy :deletable_folder

  def deletable_folder
    raise ActiveRecord::Rollback unless deletable?
  end
end
