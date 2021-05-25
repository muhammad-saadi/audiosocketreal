class Api::V1::TrackSerializer < BaseSerializer
  attributes :id, :title, :file, :status, :public_domain, :created_at

  def file
    object.file.presence && UrlHelpers.rails_blob_url(object.file)
  end

  def created_at
    formatted_date(object.created_at.localtime)
  end
end
