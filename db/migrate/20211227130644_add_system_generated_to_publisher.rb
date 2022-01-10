class AddSystemGeneratedToPublisher < ActiveRecord::Migration[6.1]
  def change
    add_column :publishers, :system_generated, :boolean, default: false
  end
end
