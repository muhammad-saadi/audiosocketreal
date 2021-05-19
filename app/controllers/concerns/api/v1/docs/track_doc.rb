module Api::V1::Docs::TracksDoc
  extend ActiveSupport::Concern

  included do
    include Api::V1::Docs

    def_param_group :doc_create_track do
      api :POST, '/v1/tracks', 'Create a new track'
      param :title, String, desc: 'Title of the track'
      param :file, File, desc: 'Music file of the track'
      param :album_id, :number, desc: 'Id of the album in which track is going to add'
    end
  end
end
