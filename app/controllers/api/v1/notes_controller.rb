class Api::V1::NotesController < Api::BaseController
  include Api::V1::Docs::NotesDoc

  param_group :doc_create_note
  def create
    @note = @current_user.notes.new(note_params)
    if @note.save
      render json: current_user.notes.pending.where(notable_type: params[:notable_type])
    else
      raise ExceptionHandler::ValidationError.new(@note.errors.to_h, 'Error setting note.')
    end
  end

  param_group :doc_notes
  def index
    render json: current_user.notes.pending.where(notable_type: params[:notable_type])
  end

  private

  def note_params
    params.permit(:description, :notable_id, :notable_type, files: [])
  end
end
