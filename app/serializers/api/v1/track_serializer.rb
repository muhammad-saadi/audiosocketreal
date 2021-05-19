class Api::V1::TrackSerializer < BaseSerializer
  attributes :id, :title, :file, :status

  def file
    object.file.presence && UrlHelpers.rails_blob_url(object.file)
  end
end
