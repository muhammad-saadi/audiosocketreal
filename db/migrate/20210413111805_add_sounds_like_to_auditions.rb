class AddSoundsLikeToAuditions < ActiveRecord::Migration[6.1]
  def change
    add_column :auditions, :sounds_like, :string
  end
end
