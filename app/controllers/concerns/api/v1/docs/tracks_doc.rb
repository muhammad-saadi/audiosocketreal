module Api::V1::Docs::TracksDoc
  extend ActiveSupport::Concern

  included do
    include Api::V1::Docs

    def_param_group :doc_tracks do
      api :GET, '/v1/album/:album_id/tracks', 'List tracks of an album'
      param :album_id, :number, desc: 'Id of the album'
    end

    def_param_group :doc_create_track do
      api :POST, '/v1/albums/:album_id/tracks', 'Create a new track'
      param :title, String, desc: 'Title of the track'
      param :file, File, desc: 'Music file of the track'
      param :public_domain, [true, false], desc: 'Public domain of track'
      param :album_id, :number, desc: 'Id of the album in which track is going to add'
    end

    def_param_group :doc_update_track do
      api :PATCH, '/v1/albums/:album_id/tracks/:id', 'Update a track'
      param :id, :number, desc: 'Id of the track'
      param :album_id, :number, desc: 'Id of the album of track'
      param :title, String, desc: 'Title of the track'
      param :public_domain, [true, false], desc: 'Public domain of track'
      param :file, File, desc: 'Music file of the track'
    end

    def_param_group :doc_show_track do
      api :GET, '/v1/albums/:album_id/tracks/:id', 'Show a track'
      param :id, :number, desc: 'Id of the track'
      param :album_id, :number, desc: 'Id of the album of track'
    end

    def_param_group :doc_destroy_track do
      api :DELETE, "/v1/albums/:id/tracks/:id", 'Delete a track'
      param :id, :number, desc: 'Id of the track'
      param :album_id, :number, desc: 'Id of the album of track'
    end
  end
end
