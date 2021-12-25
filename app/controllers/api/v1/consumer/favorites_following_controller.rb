class Api::V1::Consumer::FavoritesFollowingController < Api::V1::Consumer::BaseController
  include Api::V1::FavoritesFollowingConcern

  before_action :set_favorite_followee, only: %i[follow unfollow favorite unfavorite]

  def follow
    current_consumer.follow!(@favorite_followee)
    render json: { status: "#{params[:klass].classify} followed" }
  end

  def unfollow
    return render json: { status: "#{params[:klass].classify} unfollowed" } if current_consumer.unfollow!(@favorite_followee)

    raise ExceptionHandler::ValidationError.new(@favorite_followee.errors.to_h, "Error in unfollowing #{params[:klass].classify}.")
  end

  def favorite
    current_consumer.favorite!(@favorite_followee)
    render json: { status: "#{params[:klass].classify} added to favorites" }
  end

  def unfavorite
    return render json: { status: "#{params[:klass].classify} removed from favorites" } if current_consumer.unfavorite!(@favorite_followee)

    raise ExceptionHandler::ValidationError.new(@favorite_followee.errors.to_h, "Error in unfavoriting #{params[:klass].classify}.")
  end

  private

  def set_favorite_followee
    @favorite_followee = set_klass(params[:klass]).find_by(id: params[:id])
    response_msg(404, "Could not find #{params[:klass].titleize} with given id") if @favorite_followee.blank?
  end
end
