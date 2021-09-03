class Api::V1::Consumer::ConsumersController < Api::V1::Consumer::BaseController

  def index
    render json: Consumer.all
  end
end
