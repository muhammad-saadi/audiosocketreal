class Api::V1::Consumer::TrackSerializer < ActiveModel::Serializer

  attributes :id, :title, :wav_file, :aiff_file, :mp3_file, :status, :parent_track_id, :public_domain, :created_at, :lyrics, :explicit, :composer, :description,
             :language, :instrumental, :key, :bpm, :admin_note, :filters, :moods, :genres, :instruments, :themes, :duration, :featured, :publish_date

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

  def wav_file
    object.wav_file.presence && UrlHelpers.rails_blob_url(object.wav_file)
  end

  def aiff_file
    object.aiff_file.presence && UrlHelpers.rails_blob_url(object.aiff_file)
  end

  def mp3_file
    object.mp3_file.presence && UrlHelpers.rails_blob_url(object.mp3_file)
  end

  def created_at
    object.formatted_created_at
  end

  def publish_date
    object.formatted_publish_date
  end

  private

  def filters_by_type(filter_name)
    object.filters.select { |filter| filter.parent_filter.name_like(filter_name) }&.map(&:name)
  end
end
