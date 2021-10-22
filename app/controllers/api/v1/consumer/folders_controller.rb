class Api::V1::Consumer::FoldersController < Api::V1::Consumer::BaseController
  before_action :set_folder, only: %i[show update destroy]
  before_action :increment_usage, only: :create

  def index
    @folders = current_consumer.folders
    render json: @folders.includes(Folder.eagerload_cols(current_consumer)), meta: { count: @folders.count }, adapter: :json
  end

  def show
    render json: @folder
  end

  def create
    @folder = current_consumer.folders.new(folder_params)
    if @folder.save
      render json: @folder
    else
      raise ExceptionHandler::ValidationError.new(@folder.errors.to_h, 'Error creating folder.')
    end
  end

  def update
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
    @folder = current_consumer.folders.includes(Folder.eagerload_cols(current_consumer)).find(params[:id])
  end

  def folder_params
    params.permit(:name, :parent_folder_id)
  end

  def increment_usage
    current_consumer.increment_folder_usage!
  end
end