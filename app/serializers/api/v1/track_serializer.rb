class Api::V1::TrackSerializer < BaseSerializer
  attributes :id, :title, :file, :status, :public_domain, :created_at, :publisher, :collaborator, :lyrics, :explicit

  belongs_to :publisher, serializer: Api::V1::PublisherSerializer

  def file
    object.file.presence && UrlHelpers.rails_blob_url(object.file)
  end

  def created_at
    formatted_date(object.created_at.localtime)
  end

  def collaborator
    return if object.artists_collaborator.blank?

    Api::V1::CollaboratorSerializer.new(object.artists_collaborator)
  end
end
