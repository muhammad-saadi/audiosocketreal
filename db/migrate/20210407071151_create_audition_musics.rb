class CreateAuditionMusics < ActiveRecord::Migration[6.1]
  def change
    create_table :audition_musics do |t|
      t.string :track_link
      t.references :audition

      t.timestamps
    end
  end
end
