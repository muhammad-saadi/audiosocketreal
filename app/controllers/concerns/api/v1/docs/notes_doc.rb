module Api::V1::Docs::NotesDoc
  extend ActiveSupport::Concern

  included do
    include Api::V1::Docs

    def_param_group :doc_notes do
      api :GET, '/v1/notes', 'Get notes of object'
      param :notable_type, %w[ArtistProfile Track Album], desc: 'Class name of object'
    end

    def_param_group :doc_create_note do
      api :POST, '/v1/notes', 'Create note for object'
      param :description, String, desc: 'Description of note'
      param :files, Array, of: File, desc: 'Files for note'
      param :notable_type, %w[ArtistProfile Track Album], desc: 'Class name of object'
      param :notable_id, :number, desc: 'ID of object'
    end
  end
end
