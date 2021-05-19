class Api::V1::AlbumSerializer < BaseSerializer
  attributes :id, :name, :release_date

  def release_date
    formatted_date(object.release_date&.localtime)
  end
end
