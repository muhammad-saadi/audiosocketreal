class AddCollabortorPublisherToTracks < ActiveRecord::Migration[6.1]
  def change
    add_reference :tracks, :publisher
    add_reference :tracks, :collaborator
  end
end
