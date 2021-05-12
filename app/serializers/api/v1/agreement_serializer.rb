class Api::V1::AgreementSerializer < BaseSerializer
  attributes :id, :content, :file, :agreement_type

  def file
    object.attachment.presence && UrlHelpers.rails_blob_url(object.attachment)
  end
end
