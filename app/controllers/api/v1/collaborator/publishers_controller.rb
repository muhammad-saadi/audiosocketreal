class Api::V1::Collaborator::PublishersController < Api::V1::Collaborator::BaseController
  include Api::V1::Docs::Collaborator::PublishersDoc

  allow_access roles: ['collaborator'], access: %w[read write], only: %i[index]

  param_group :doc_publishers
  def index
    @publishers = @current_artist.publishers.ordered.pagination(pagination_params)
    render json: @publishers, meta: { count: @publishers.count }, each_serializer: Api::V1::PublisherSerializer, adapter: :json
  end
end
