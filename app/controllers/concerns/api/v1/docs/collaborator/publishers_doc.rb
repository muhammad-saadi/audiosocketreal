module Api::V1::Docs::Collaborator::PublishersDoc
  extend ActiveSupport::Concern

  included do
    include Api::V1::Docs::Collaborator

    def_param_group :doc_publishers do
      api :GET, '/v1/collaborator/publishers', 'List all publishers of current artist'
      param :artist_id, :number, desc: "ID of the artist", required: true
      param :page, :number, desc: 'Page number'
      param :per_page, :number, desc: 'Maximum number of records per page'
      param :pagination, ['true', 'false', true, false], desc: 'Send false to avoid default pagination'
    end
  end
end
