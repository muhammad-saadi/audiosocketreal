class Api::V1::TrackSerializer < BaseSerializer
  attributes :id, :title, :file, :status, :public_domain, :created_at, :publisher, :collaborator, :lyrics, :explicit, :composer, :description, :language, :instrumental, :key, :bpm, :admin_note, :filters

  belongs_to :publisher, serializer: Api::V1::PublisherSerializer

  def file
    object.file.presence && UrlHelpers.rails_blob_url(object.file)
  end

  def created_at
    object.formatted_created_at
  end

  def collaborator
    return if object.artists_collaborator.blank?

    Api::V1::CollaboratorSerializer.new(object.artists_collaborator)
  end
end
