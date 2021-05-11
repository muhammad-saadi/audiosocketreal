module Api::V1::Docs::GenresDoc
  extend ActiveSupport::Concern

  included do
    include Api::V1::Docs

    def_param_group :doc_genres do
      api :GET, '/genres', 'List all genres in sorted order'
    end
  end
end
