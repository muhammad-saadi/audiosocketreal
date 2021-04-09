class AddAssigneeReferenceToAudition < ActiveRecord::Migration[6.1]
  def change
    add_reference :auditions, :assignee
  end
end
