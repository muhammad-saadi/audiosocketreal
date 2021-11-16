class CreateFavoriteFollows < ActiveRecord::Migration[6.1]
  def change
    create_table :favorite_follows do |t|
      t.string :kind
      t.references :favorite_followable, polymorphic: true
      t.references :favorite_follower, polymorphic: true

      t.timestamps
    end
  end
end
