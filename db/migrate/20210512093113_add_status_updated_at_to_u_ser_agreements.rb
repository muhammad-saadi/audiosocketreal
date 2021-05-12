class AddStatusUpdatedAtToUSerAgreements < ActiveRecord::Migration[6.1]
  def change
    add_column :users_agreements, :status_updated_at, :datetime
  end
end
