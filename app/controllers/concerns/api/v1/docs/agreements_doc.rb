module Api::V1::Docs::AgreementsDoc
  extend ActiveSupport::Concern

  included do
    include Api::V1::Docs

    def_param_group :doc_agreements do
      api :GET, '/v1/agreements', 'List all agreements of current user'
    end
  end
end
