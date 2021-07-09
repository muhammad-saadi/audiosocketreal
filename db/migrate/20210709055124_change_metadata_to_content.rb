class ChangeMetadataToContent < ActiveRecord::Migration[6.1]
  def change
    rename_table :metadata, :contents
  end
end
