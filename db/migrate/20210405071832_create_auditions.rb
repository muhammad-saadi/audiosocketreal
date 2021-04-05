class CreateAuditions < ActiveRecord::Migration[6.1]
  def change
    create_table :auditions do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :artist_name
      t.string :reference_company
      t.boolean :exclusive_artist
      t.string :sounds_like
      t.string :genre
      t.string :how_you_know_us
      t.string :status, default: 'pending'
      t.datetime :status_updated_at
      t.string :note

      t.timestamps
    end
  end
end
