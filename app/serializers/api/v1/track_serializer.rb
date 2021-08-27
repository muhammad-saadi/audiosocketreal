class Api::V1::TrackSerializer < BaseSerializer
  attributes :id, :title, :file, :status, :public_domain, :created_at, :lyrics, :explicit, :composer, :description,
             :language, :instrumental, :key, :bpm, :admin_note, :filters, :publishers, :artists_collaborators

  def file
    object.file.presence && UrlHelpers.rails_blob_url(object.file)
  end

  def created_at
    object.formatted_created_at
  end

  def publishers
    object.track_publishers.map do |track_publisher|
      {
        id: track_publisher.publisher.id,
        name: track_publisher.publisher.name,
        pro: track_publisher.publisher.pro,
        ipi: track_publisher.publisher.ipi,
        percentage: track_publisher.percentage
      }
    end
  end

  def artists_collaborators
    object.track_writers.map do |track_writer|
      {
        id: track_writer.artists_collaborator.id,
        first_name: track_writer.artists_collaborator.collaborator.first_name,
        last_name: track_writer.artists_collaborator.collaborator.last_name,
        email: track_writer.artists_collaborator.collaborator.email,
        status: track_writer.artists_collaborator.status,
        access: track_writer.artists_collaborator.access,
        percentage: track_writer.percentage
      }
    end
  end
end
