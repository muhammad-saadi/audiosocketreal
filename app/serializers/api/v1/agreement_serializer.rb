class Api::V1::AgreementSerializer < ActiveModel::Serializer
  attributes :id, :content, :file

  def file
    object.attachment.presence && UrlHelpers.rails_blob_url(object.attachment)
  end
end
