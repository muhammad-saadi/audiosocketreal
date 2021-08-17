class ChangeFieldsToText < ActiveRecord::Migration[6.1]
  def up
    change_table :tracks do |t|
      t.change :description, :text
      t.change :admin_note, :text
    end
  end
  def down
    change_table :tracks do |t|
      t.change :description, :string
       t.change :admin_note, :string
    end
  end
end
