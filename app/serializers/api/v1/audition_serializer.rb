class Api::V1::AuditionSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :artist_name, :reference_company, :exclusive_artist, :sounds_like,
             :genre, :how_you_know_us, :status, :status_updated_at, :note
end
