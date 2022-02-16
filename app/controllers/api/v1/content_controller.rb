class Api::V1::ContentController < Api::BaseController
  before_action :set_content

  def show
    render json: { content: @content&.content }
  end

  private

  def set_content
    @content = Content.find_by(key: params[:key])
  end
end
