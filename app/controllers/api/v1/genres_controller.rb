class Api::V1::GenresController < Api::BaseController
  def index
    @genres = Genre.all
    render json: @genres
  end
end
