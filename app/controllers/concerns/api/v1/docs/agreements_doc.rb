module Api::V1::Docs::AgreementsDoc
  extend ActiveSupport::Concern

  included do
    include Api::V1::Docs

    def_param_group :doc_agreements do
      api :GET, '/v1/agreements', 'List all agreements of current user'
    end

    def_param_group :doc_update_status do
      api :PATCH, '/v1/agreements/update_status', 'Accept/Reject an agreement'
      param :id, :number, desc: 'Id of agreement', required: true
      param :status, UsersAgreement.statuses.keys, desc: 'New value of status', required: true
    end
  end
end
