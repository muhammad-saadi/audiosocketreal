class RenameCollaboratorReferenceInTrack < ActiveRecord::Migration[6.1]
  def change
    remove_reference :tracks, :collaborator
    add_reference :tracks, :artists_collaborator
  end
end
