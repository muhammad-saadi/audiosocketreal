class Api::V1::NoteSerializer < BaseSerializer
  attributes :id, :description, :files, :notable_type, :notable_id, :status

  def files
    object.files.map{ |image| UrlHelpers.rails_blob_url(image) }
  end
end
