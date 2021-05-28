module Api::V1::Docs::PublishersDoc
  extend ActiveSupport::Concern

  included do
    include Api::V1::Docs

    def_param_group :doc_publishers do
      api :GET, '/v1/publishers', 'List all publishers of current user'
    end

    def_param_group :doc_create_publishers do
      api :POST, '/v1/publishers', 'Create a publisher'
      param :name, String, desc: 'Name of publisher'
    end

    def_param_group :doc_update_publishers do
      api :PATCH, '/v1/publishers/:id', 'Update a publisher'
      param :id, :number, desc: 'ID of publisher to be update'
      param :name, String, desc: 'Name of publisher'
    end
  end
end
