class Api::V1::Consumer::SfxSerializer < ActiveModel::Serializer

  attributes :id, :title, :file, :description, :keyword, :duration, :created_at

  has_many :filters, serializer: Api::V1::FilterSerializer

  def file
    object.file.presence && UrlHelpers.rails_blob_url(object.file)
  end

  def created_at
    object.formatted_created_at
  end
end
