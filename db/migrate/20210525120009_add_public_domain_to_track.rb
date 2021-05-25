class AddPublicDomainToTrack < ActiveRecord::Migration[6.1]
  def change
    add_column :tracks, :public_domain, :boolean
  end
end
