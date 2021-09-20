class Api::V1::Consumer::TrackSerializer < ActiveModel::Serializer
  attributes :id, :title, :file, :status, :parent_track_id, :public_domain, :created_at, :lyrics, :explicit, :composer, :description,
             :language, :instrumental, :key, :bpm, :admin_note, :filters, :genre

  has_many :filters, serializer: Api::V1::FilterSerializer
  has_many :alternate_versions, serializer: Api::V1::TrackSerializer

  def genre
    object.filters.select { |filter| filter.parent_filter.name.downcase.include?('genres') }
  end

  def file
    object.file.presence && UrlHelpers.rails_blob_url(object.file)
  end

  def created_at
    object.formatted_created_at
  end
end
