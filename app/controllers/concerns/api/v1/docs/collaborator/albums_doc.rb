module Api::V1::Docs::Collaborator::AlbumsDoc
  extend ActiveSupport::Concern

  included do
    include Api::V1::Docs::Collaborator

    def_param_group :doc_albums do
      api :GET, "/v1/collaborator/albums", 'List albums of current artist'
      param :artist_id, :number, desc: "ID of the artist", required: true
      param :page, :number, desc: 'Page number'
      param :per_page, :number, desc: 'Maximum number of records per page'
      param :pagination, ['true', 'false', true, false], desc: 'Send false to avoid default pagination'
    end

    def_param_group :doc_create_album do
      api :POST, "/v1/collaborator/albums", 'Create an new album'
      param :artist_id, :number, desc: "ID of the artist", required: true
      param :name, String, desc: 'Name of the album'
      param :release_date, DateTime, desc: 'Date of releasing album'
    end

    def_param_group :doc_update_album do
      api :PATCH, "/v1/collaborator/albums/:id", 'Update an album'
      param :artist_id, :number, desc: "ID of the artist", required: true
      param :id, :number, desc: 'id of the album'
      param :name, String, desc: 'Name of the album'
      param :release_date, DateTime, desc: 'Date of releasing album'
    end

    def_param_group :doc_show_album do
      api :GET, "/v1/collaborator/albums/:id", 'Show an album'
      param :artist_id, :number, desc: "ID of the artist", required: true
      param :id, :number, desc: 'id of the album'
    end

    def_param_group :doc_destroy_album do
      api :DELETE, "/v1/collaborator/albums/:id", 'Delete an album'
      param :artist_id, :number, desc: "ID of the artist", required: true
      param :id, :number, desc: 'id of the album'
    end

    def_param_group :doc_update_artwork do
      api :PATCH, "/v1/collaborator/albums/:id/update_artwork", "Update an album's artwork"
      param :artist_id, :number, desc: "ID of the artist", required: true
      param :id, :number, desc: 'id of the album'
      param :artwork, File, desc: 'Image file for artwork'
    end
  end
end
