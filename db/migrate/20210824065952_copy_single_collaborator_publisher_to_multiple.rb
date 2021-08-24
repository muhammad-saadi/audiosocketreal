class CopySingleCollaboratorPublisherToMultiple < ActiveRecord::Migration[6.1]
  def up
    Track.all.each do |track|
      track.publishers << track.publisher if track.publisher.present?
      track.artists_collaborators << track.artists_collaborator if track.artists_collaborator.present?
    end
  end

  def down
    TrackPublisher.destroy_all
    TrackWriter.destroy_all
  end
end
