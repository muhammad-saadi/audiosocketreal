class Api::V1::GenresController < Api::BaseController
  include Api::V1::Docs::GenresDoc

  skip_before_action :authenticate_user!
  param_group :doc_genres
  def index
    render json: Genre.order('LOWER(name)')
  end
end
