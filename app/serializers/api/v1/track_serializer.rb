class Api::V1::TrackSerializer < BaseSerializer
  attributes :id, :title, :file, :status, :public_domain, :created_at, :lyrics, :explicit, :composer, :description,
             :language, :instrumental, :key, :bpm, :admin_note, :filters, :publishers, :artists_collaborators

  has_many :publishers, each_serializer: Api::V1::PublisherSerializer
  has_many :artists_collaborators, each_serializer: Api::V1::CollaboratorSerializer

  def file
    object.file.presence && UrlHelpers.rails_blob_url(object.file)
  end

  def created_at
    object.formatted_created_at
  end

  def artists_collaborators
    object.artists_collaborators.map do |artists_collaborator|
      {
        id: artists_collaborator.id,
        first_name: artists_collaborator.collaborator.first_name,
        last_name: artists_collaborator.collaborator.last_name,
        email: artists_collaborator.collaborator.email
      }
    end
  end
end
