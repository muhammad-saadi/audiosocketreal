class Api::V1::ContentController < Api::BaseController
  include Api::V1::Docs::ContentDoc

  before_action :set_content

  param_group :doc_content
  def show
    render json: { content: @content&.content }
  end

  private

  def set_content
    @content = Content.find_by(key: params[:key])
  end
end
