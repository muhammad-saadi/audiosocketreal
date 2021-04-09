class Api::V1::AuditionSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :artist_name, :reference_company, :exclusive_artist,
              :how_you_know_us, :status, :status_updated_at, :note

  has_many :genres
  has_many :audition_musics
  belongs_to :assignee, class_name: 'User'
end
