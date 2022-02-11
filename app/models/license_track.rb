class LicenseTrack < ApplicationRecord
  belongs_to :mediable, polymorphic: true 
  belongs_to :license
end
