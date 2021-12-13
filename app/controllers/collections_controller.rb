class CollectionsController < ApplicationController
def license
  render json: Collection.where(id: params[:ids]).includes(:licenses).distinct.pluck(:license_id, :name).flatten(1)
end
end
