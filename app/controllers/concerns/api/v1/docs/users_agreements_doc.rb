module Api::V1::Docs::UsersAgreementsDoc
  extend ActiveSupport::Concern

  included do
    include Api::V1::Docs

    def_param_group :doc_users_agreements do
      api :GET, '/v1/users_agreements', 'List all agreements of current user with detail'
    end

    def_param_group :doc_update_status do
      api :PATCH, '/v1/users_agreements/:id/update_status', 'Accept/Reject an agreement'
      param :id, :number, desc: 'Id of users_agreement', required: true
      param :status, UsersAgreement.statuses.keys, desc: 'New value of status', required: true
    end
  end
end
