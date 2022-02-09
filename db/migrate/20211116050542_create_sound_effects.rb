class CreateSoundEffects < ActiveRecord::Migration[6.1]
  def change
    create_table :sfxes do |t|
      t.string :title
      t.text :description
      t.string :keyword
      t.timestamps
    end
  end
end
