class Api::V1::GenresController < Api::BaseController
  def index
    render json: Genre.order('LOWER(name)')
  end
end
