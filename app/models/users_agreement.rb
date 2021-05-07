class UsersAgreement < ApplicationRecord
  belongs_to :user
  belongs_to :agreement

  def status_hash
    {
      id: id,
      agreement: agreement.content,
      agreement_file: agreement.attachment.presence && Rails.application.routes.url_helpers.rails_blob_url(agreement.attachment),
      status: status
    }
  end
end
