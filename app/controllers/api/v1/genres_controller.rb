class Api::V1::GenresController < Api::BaseController
  skip_before_action :authenticate_user!

  def index
    render json: Genre.order('LOWER(name)')
  end
end
