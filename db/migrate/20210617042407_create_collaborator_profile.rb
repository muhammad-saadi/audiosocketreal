class CreateCollaboratorProfile < ActiveRecord::Migration[6.1]
  def change
    create_table :collaborator_profiles do |t|
      t.string :pro
      t.string :ipi
      t.boolean :different_registered_name

      t.references :artists_collaborator
      t.timestamps
    end
  end
end
