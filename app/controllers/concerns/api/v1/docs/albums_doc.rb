module Api::V1::Docs::AlbumsDoc
  extend ActiveSupport::Concern

  included do
    include Api::V1::Docs

    def_param_group :doc_albums do
      api :GET, "/v1/albums", 'List albums of current user'
    end

    def_param_group :doc_create_album do
      api :POST, "/v1/albums", 'Create an new album'
      param :name, String, desc: 'Name of the album'
      param :release_date, DateTime, desc: 'Date of releasing album'
    end

    def_param_group :doc_update_album do
      api :PATCH, "/v1/albums/:id", 'Update an album'
      param :id, :number, desc: 'id of the album'
      param :name, String, desc: 'Name of the album'
      param :release_date, DateTime, desc: 'Date of releasing album'
    end

    def_param_group :doc_show_album do
      api :GET, "/v1/albums/:id", 'Show an album'
      param :id, :number, desc: 'id of the album'
    end

    def_param_group :doc_destroy_album do
      api :DELETE, "/v1/albums/:id", 'Delete an album'
      param :id, :number, desc: 'id of the album'
    end

    def_param_group :doc_update_artork do
      api :PATCH, "/v1/albums/:id/update_artwork", "Update an album's artwork"
      param :id, :number, desc: 'id of the album'
      param :artwork, File, desc: 'Image file for artwork'
    end
  end
end
