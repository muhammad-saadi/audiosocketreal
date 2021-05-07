class Api::V1::UsersAgreementSerializer < ActiveModel::Serializer
  attributes :id, :agreement, :status

  belongs_to :agreement
end
