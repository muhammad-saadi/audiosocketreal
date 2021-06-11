module Api::V1::Docs::Collaborator::TracksDoc
  extend ActiveSupport::Concern

  included do
    include Api::V1::Docs::Collaborator

    def_param_group :doc_tracks do
      api :GET, '/v1/collaborator/album/:album_id/tracks', 'List tracks of an album'
      param :artist_id, :number, desc: "ID of the artist", required: true
      param :album_id, :number, desc: 'Id of the album'
      param :page, :number, desc: 'Page number'
      param :per_page, :number, desc: 'Maximum number of records per page'
      param :pagination, ['true', 'false', true, false], desc: 'Send false to avoid default pagination'
    end

    def_param_group :doc_create_track do
      api :POST, '/v1/collaborator/albums/:album_id/tracks', 'Create a new track'
      param :artist_id, :number, desc: "ID of the artist", required: true
      param :title, String, desc: 'Title of the track'
      param :file, File, desc: 'Music file of the track'
      param :public_domain, [true, false], desc: 'Public domain of track'
      param :album_id, :number, desc: 'Id of the album in which track is going to add'
      param :collaborator_id, :number, desc: "Id of tracks's collaborator"
      param :publisher_id, :number, desc: "Id of track's publisher"
      param :status, String, desc: "Status of the track"
    end

    def_param_group :doc_update_track do
      api :PATCH, '/v1/collaborator/albums/:album_id/tracks/:id', 'Update a track'
      param :artist_id, :number, desc: "ID of the artist", required: true
      param :id, :number, desc: 'Id of the track'
      param :album_id, :number, desc: 'Id of the album of track'
      param :title, String, desc: 'Title of the track'
      param :public_domain, [true, false], desc: 'Public domain of track'
      param :file, File, desc: 'Music file of the track'
      param :collaborator_id, :number, desc: "Id of tracks's collaborator"
      param :publisher_id, :number, desc: "Id of track's publisher"
      param :status, String, desc: "Status of the track"
    end

    def_param_group :doc_show_track do
      api :GET, '/v1/collaborator/albums/:album_id/tracks/:id', 'Show a track'
      param :artist_id, :number, desc: "ID of the artist", required: true
      param :id, :number, desc: 'Id of the track'
      param :album_id, :number, desc: 'Id of the album of track'
    end

    def_param_group :doc_destroy_track do
      api :DELETE, "/v1/collaborator/albums/:id/tracks/:id", 'Delete a track'
      param :artist_id, :number, desc: "ID of the artist", required: true
      param :id, :number, desc: 'Id of the track'
      param :album_id, :number, desc: 'Id of the album of track'
    end
  end
end
