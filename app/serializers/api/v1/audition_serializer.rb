class Api::V1::AuditionSerializer < BaseSerializer
  attributes :id, :first_name, :last_name, :email, :artist_name, :reference_company, :exclusive_artist,
              :how_you_know_us, :status, :status_updated_at, :sounds_like, :remarks, :submitted_at

  has_many :genres
  has_many :audition_musics

  belongs_to :assignee

  def status_updated_at
    formatted_datetime(object.status_updated_at&.localtime)
  end

  def submitted_at
    object.formatted_created_at
  end
end
