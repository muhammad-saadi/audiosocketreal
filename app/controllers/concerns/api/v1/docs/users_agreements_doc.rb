module Api::V1::Docs::UsersAgreementsDoc
  extend ActiveSupport::Concern

  included do
    include Api::V1::Docs

    def_param_group :doc_users_agreements do
      api :GET, '/v1/users_agreements', 'List all agreements of current user with detail'
    end
  end
end
