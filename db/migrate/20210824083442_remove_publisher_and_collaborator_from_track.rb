class RemovePublisherAndCollaboratorFromTrack < ActiveRecord::Migration[6.1]
  def change
    remove_reference :tracks, :publisher
    remove_reference :tracks, :artists_collaborator
  end
end
