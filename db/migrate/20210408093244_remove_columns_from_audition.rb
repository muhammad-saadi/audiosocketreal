class RemoveColumnsFromAudition < ActiveRecord::Migration[6.1]
  def change
    remove_column :auditions, :sounds_like, :string
    remove_column :auditions, :genre, :string
  end
end
