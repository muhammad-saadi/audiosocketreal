module Api::V1::Docs::PublishersDoc
  extend ActiveSupport::Concern

  included do
    include Api::V1::Docs

    def_param_group :doc_publishers do
      api :GET, '/v1/publishers', 'List all publishers of current user'
      param :page, :number, desc: 'Page number'
      param :per_page, :number, desc: 'Maximum number of records per page'
      param :pagination, ['true', 'false', true, false], desc: 'Send false to avoid default pagination'
    end

    def_param_group :doc_create_publishers do
      api :POST, '/v1/publishers', 'Create a publisher'
      param :name, String, desc: 'Name of publisher'
      param :pro, String, desc: 'PRO of publisher'
      param :ipi, String, desc: 'CAE/IPI of publisher'
    end

    def_param_group :doc_update_publishers do
      api :PATCH, '/v1/publishers/:id', 'Update a publisher'
      param :id, :number, desc: 'ID of publisher to be update'
      param :name, String, desc: 'Name of publisher'
      param :pro, String, desc: 'PRO of publisher'
      param :ipi, String, desc: 'CAE/IPI of publisher'
    end

    def_param_group :doc_destroy_publisher do
      api :DELETE, "/v1/publishers/:id", 'Delete a publisher'
      param :id, :number, desc: 'Id of the publisher'
    end
  end
end
