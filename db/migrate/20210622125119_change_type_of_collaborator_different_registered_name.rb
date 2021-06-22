class ChangeTypeOfCollaboratorDifferentRegisteredName < ActiveRecord::Migration[6.1]
  def up
    change_column :collaborator_profiles, :different_registered_name, :string
  end

  def down
    change_column :collaborator_profiles, :different_registered_name, 'boolean USING CAST(different_registered_name AS boolean)'
  end
end
