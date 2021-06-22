class ChangeColumnTypeOfCollaborator < ActiveRecord::Migration[6.1]
  def change
    def self.up
      change_column :collaborator_profiles, :different_registered_name, :string
    end

    def self.down
      change_column :collaborator_profiles, :different_registered_name, :boolean
    end
  end
end
