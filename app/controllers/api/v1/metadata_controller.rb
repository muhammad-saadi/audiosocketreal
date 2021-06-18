class Api::V1::MetadataController < Api::BaseController
  include Api::V1::Docs::MetadataDoc

  param_group :doc_metadata
  def show
    render json: { content: Metadata.find_by(key: params[:key])&.content }
  end
end
