class Api::V1::Collaborator::NotesController < Api::V1::Collaborator::BaseController
  include Api::V1::Docs::Collaborator::NotesDoc

  allow_access roles: ['collaborator'], access: %w[read write], only: %i[index]
  allow_access roles: ['collaborator'], access: %w[write], only: %i[create]

  param_group :doc_create_note
  def create
    @note = @current_artist.notes.new(note_params)
    if @note.save
      render json: @current_artist.notes.pending.where(notable_type: params[:notable_type], notable_id: params[:notable_id]),
             each_serializer: Api::V1::NoteSerializer
    else
      raise ExceptionHandler::ValidationError.new(@note.errors.to_h, 'Error setting note.')
    end
  end

  param_group :doc_notes
  def index
    render json: @current_artist.notes.pending.where(notable_type: params[:notable_type], notable_id: params[:notable_id]),
           each_serializer: Api::V1::NoteSerializer
  end

  private

  def note_params
    params.permit(:description, :notable_id, :notable_type, files: [])
  end
end
