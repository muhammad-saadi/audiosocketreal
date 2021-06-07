class Api::V1::UsersAgreementSerializer < BaseSerializer
  attributes :id, :agreement, :status, :role, :status_updated_at

  belongs_to :agreement

  def status_updated_at
    formatted_date(object.status_updated_at&.localtime)
  end
end
