class CreateAgreements < ActiveRecord::Migration[6.1]
  def change
    create_table :agreements do |t|
      t.text :content

      t.timestamps
    end
  end
end
