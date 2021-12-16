class Api::V1::Consumer::TrackSerializer < ActiveModel::Serializer

  attributes :id, :title, :file, :status, :parent_track_id, :public_domain, :created_at, :lyrics, :explicit, :composer, :description,
             :language, :instrumental, :key, :bpm, :admin_note, :filters, :moods, :genres, :instruments, :themes, :duration

  has_many :filters, serializer: Api::V1::FilterSerializer
  has_many :alternate_versions, serializer: Api::V1::TrackSerializer

  def moods
    filters_by_type(Filter::MOODS)
  end

  def genres
    filters_by_type(Filter::GENRES)
  end

  def instruments
    filters_by_type(Filter::INSTRUMENTS)
  end

  def themes
    filters_by_type(Filter::THEMES)
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

  private

  def filters_by_type(filter_name)
    object.filters.select { |filter| filter.parent_filter.name_like(filter_name) }&.map(&:name)
  end
end
