class Api::V1::MetadataController < Api::BaseController
  include Api::V1::Docs::MetadataDoc

  before_action :set_metadata

  param_group :doc_metadata
  def show
    render json: { content: @metadata&.content }
  end

  private

  def set_metadata
    @metadata = Metadata.find_by(key: params[:key])
  end
end
