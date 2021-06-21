module Api::V1::Docs::Collaborator::NotesDoc
  extend ActiveSupport::Concern

  included do
    include Api::V1::Docs::Collaborator

    def_param_group :doc_notes do
      api :GET, '/v1/collaborator/notes', 'Get notes of object'
      param :artist_id, :number, desc: "ID of the artist", required: true
      param :notable_type, %w[ArtistProfile Track Album], desc: 'Class name of object'
      param :notable_id, :number, desc: 'ID of object'
    end

    def_param_group :doc_create_note do
      api :POST, '/v1/collaborator/notes', 'Create note for object'
      param :artist_id, :number, desc: "ID of the artist", required: true
      param :description, String, desc: 'Description of note'
      param :files, Array, of: File, desc: 'Files for note'
      param :notable_type, %w[ArtistProfile Track Album], desc: 'Class name of object'
      param :notable_id, :number, desc: 'ID of object'
    end
  end
end
