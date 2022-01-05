class Api::V1::Consumer::TrackSerializer < ActiveModel::Serializer

  attributes :id, :title, :mp3_file, :wav_file, :aiff_file, :status, :parent_track_id, :public_domain, :created_at, :lyrics, :explicit, :composer, :description, :language, :instrumental, :key, :bpm, :admin_note, :filters, :genre, :moods, :duration

  has_many :filters, serializer: Api::V1::FilterSerializer
  has_many :alternate_versions, serializer: Api::V1::TrackSerializer

  def genre
    object.filters.select { |filter| filter.parent_filter.name.downcase.include?('genres') }
  end

  def moods
    object.filters.select { |filter| filter.parent_filter.name.downcase.include?('moods') }.pluck(:name)
  end

  def mp3_file
    object.mp3_file.presence && UrlHelpers.rails_blob_url(object.mp3_file)
  end

  def wav_file
    object.wav_file.presence && UrlHelpers.rails_blob_url(object.wav_file)
  end

  def aiff_file
    object.aiff_file.presence && UrlHelpers.rails_blob_url(object.aiff_file)
  end

  def duration
    object.mp3_file&.metadata.to_h["duration"]&.round(2)
  end

  def created_at
    object.formatted_created_at
  end
end
