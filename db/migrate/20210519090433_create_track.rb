class CreateTrack < ActiveRecord::Migration[6.1]
  def change
    create_table :tracks do |t|
      t.string :title
      t.string :status, default: 'pending'

      t.references :album
      t.timestamps
    end
  end
end
