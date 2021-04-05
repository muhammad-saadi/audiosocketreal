class AddIndexToAuditionEmail < ActiveRecord::Migration[6.1]
  def change
    add_index :auditions, [:email, :status]
  end
end
