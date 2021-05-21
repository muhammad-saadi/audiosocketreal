class CreateArtistsCollaborator < ActiveRecord::Migration[6.1]
  def change
    create_table :artists_collaborators do |t|
      t.string :status, default: 'pending'

      t.references :artist, foreign_key: { to_table: :users }
      t.references :collaborator, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
