class Api::V1::AuditionsController < Api::BaseController
  def index
    render json: { message: 'Hello World' }
  end
end
