class CopySingleCollaboratorPublisherToMultiple < ActiveRecord::Migration[6.1]
  def up
    Track.all.each do |track|
      publisher =  Publisher.find_by(id: track.publisher_id)
      track.publishers << publisher if publisher.present?
      artists_collaborator = ArtistsCollaborator.find_by(id: track.artists_collaborator_id)
      track.artists_collaborators << artists_collaborator if artists_collaborator.present?
    end
  end

  def down
    TrackPublisher.destroy_all
    TrackWriter.destroy_all
  end
end
