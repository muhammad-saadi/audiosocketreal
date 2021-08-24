class Api::V1::TrackSerializer < BaseSerializer
  attributes :id, :title, :file, :status, :public_domain, :created_at, :lyrics, :explicit, :composer, :description,
             :language, :instrumental, :key, :bpm, :admin_note, :filters, :publishers, :artists_collaborators

  has_many :publishers, serializer: Api::V1::PublisherSerializer
  has_many :artists_collaborators, serializer: Api::V1::CollaboratorSerializer

  def file
    object.file.presence && UrlHelpers.rails_blob_url(object.file)
  end

  def created_at
    object.formatted_created_at
  end
end
