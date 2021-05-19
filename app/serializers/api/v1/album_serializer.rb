class Api::V1::AlbumSerializer < BaseSerializer
  attributes :id, :name, :release_date

  has_many :tracks

  def release_date
    formatted_date(object.release_date&.localtime)
  end
end
