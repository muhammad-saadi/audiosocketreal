class CreateArtistsCollaborator < ActiveRecord::Migration[6.1]
  def change
    create_table :artists_collaborators do |t|
      t.string :status, default: 'pending'
      t.string :access

      t.references :artist, foreign_key: { to_table: :users }
      t.references :collaborator, foreign_key: { to_table: :users }

      t.index %i[collaborator_id artist_id], unique: true
      t.index %i[artist_id collaborator_id], unique: true

      t.timestamps
    end
  end
end
