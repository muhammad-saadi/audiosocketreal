class ChangeColumnTypeOfCollaborator < ActiveRecord::Migration[6.1]
  def change
    change_column :collaborator_profiles, :different_registered_name, :string
  end
end
