class Api::V1::Consumer::FolderSerializer < ActiveModel::Serializer
  attributes :id, :name, :consumer_playlists, :sub_folders

  def consumer_playlists
    object.consumer_playlists&.map { |consumer_playlist| Api::V1::Consumer::ConsumerPlaylistSerializer.new(consumer_playlist) }
  end

  def sub_folders
    object.sub_folders&.map { |folder| Api::V1::Consumer::FolderSerializer.new(folder) }
  end
end
