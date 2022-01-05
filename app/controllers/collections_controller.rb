class CollectionsController < ApplicationController
  def license
    render json: Collection.where(id: params[:ids]).includes(:licenses).distinct.pluck(:license_id).flatten(1)
  end
end
