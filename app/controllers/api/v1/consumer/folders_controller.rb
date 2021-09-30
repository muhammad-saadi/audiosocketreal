class Api::V1::Consumer::FoldersController < Api::V1::Consumer::BaseController

  before_action :set_folder, only: %i[show update destroy]

  def index
    @folders = current_consumer.folders
    render json: @folders.includes(:consumer_playlists), meta: {count: @folders.count}, adapter: :json
  end

  def show
    render json: @folder
  end

  def create
    @folder = current_consumer.folders.new(folder_params)
    set_parent_folder if params[:parent_folder_id].present?
    if @folder.save
      render json: @folder
    else
      raise ExceptionHandler::ValidationError.new(@folder.errors.to_h, 'Error creating folder.')
    end
  end

  def update
    set_parent_folder if params[:parent_folder_id].present?
    if @folder.update(folder_params)
      render json: @folder
    else
      raise ExceptionHandler::ValidationError.new(@folder.errors.to_h, 'Error updating folder.')
    end
  end

  def destroy
    if @folder.destroy
      render json: current_consumer.folders
    else
      raise ExceptionHandler::ValidationError.new(@folder.errors.to_h, 'Error deleting folder.')
    end
  end

  private

  def set_folder
    @folder = current_consumer.folders.includes(:consumer_playlists).find(params[:id])
  end

  def folder_params
    params.permit(:name)
  end

  def set_parent_folder
    @folder.parent_folder = current_consumer.folders.find(params[:parent_folder_id])
  end
end
