class CreateAuditionsGenres < ActiveRecord::Migration[6.1]
  def change
    create_table :auditions_genres do |t|
      t.references :audition
      t.references :genre

      t.timestamps
    end
  end
end
