class AddProAndIpiToPublishers < ActiveRecord::Migration[6.1]
  def change
    add_column :publishers, :pro, :string
    add_column :publishers, :ipi, :string
  end
end
