module Api::V1::Docs::ContentDoc
  extend ActiveSupport::Concern

  included do
    include Api::V1::Docs

    def_param_group :doc_content do
      api :GET, '/v1/content/:key', 'Content against given field'
      param :key, String, desc: 'key of data'
    end
  end
end
