class Api::V1::Consumer::TrackSerializer < ActiveModel::Serializer

  attributes :id, :title, :file, :status, :parent_track_id, :public_domain, :created_at, :lyrics, :explicit, :composer, :description,
             :language, :instrumental, :key, :bpm, :admin_note, :filters, :moods, :genres, :instruments, :themes

  has_many :filters, serializer: Api::V1::FilterSerializer
  has_many :alternate_versions, serializer: Api::V1::TrackSerializer

  def moods
    object.filters.parent_sub_filters(Filter::MOODS)
  end

  def genres
    object.filters.parent_sub_filters(Filter::GENRES)
  end

  def instruments
    object.filters.parent_sub_filters(Filter::INSTRUMENTS)
  end

  def themes
    object.filters.parent_sub_filters(Filter::THEMES)
  end

  def file
    object.file.presence && UrlHelpers.rails_blob_url(object.file)
  end

  def duration
    object.file&.metadata.to_h["duration"]&.round(2)
  end

  def created_at
    object.formatted_created_at
  end
end
