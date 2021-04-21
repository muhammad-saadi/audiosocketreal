class RenameNoteToRemarksInAuditions < ActiveRecord::Migration[6.1]
  def change
    rename_column :auditions, :note, :remarks
  end
end
