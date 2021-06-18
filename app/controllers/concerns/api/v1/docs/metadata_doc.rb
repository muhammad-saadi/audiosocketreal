module Api::V1::Docs::MetadataDoc
  extend ActiveSupport::Concern

  included do
    include Api::V1::Docs

    def_param_group :doc_metadata do
      api :GET, '/v1/genres/:key', 'Content against given field'
      param :key, String, desc: 'key of data'
    end
  end
end
