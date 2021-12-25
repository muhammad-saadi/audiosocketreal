class Api::V1::Consumer::ConsumersController < Api::V1::Consumer::BaseController
  include Api::V1::PlaylistsConcern

  before_action :validate_password, only: %i[update_email update_password]

  def show_profile
    render json: current_consumer
  end

  def update_email
    if current_consumer.update(email: params[:email])
      render json: current_consumer
    else
      raise ExceptionHandler::ValidationError.new(current_consumer.errors.to_h, 'Error updating email.')
    end
  end

  def update_password
    if current_consumer.update(password_params)
      render json: current_consumer
    else
      raise ExceptionHandler::ValidationError.new(current_consumer.errors.to_h, 'Error updating password.')
    end
  end

  def update_profile
    if current_consumer.update(consumer_profile_params)
      render json: current_consumer
    else
      raise ExceptionHandler::ValidationError.new(current_consumer.errors.to_h, 'Error updating profile.')
    end
  end

  def favorite_tracks
    @tracks = current_consumer.favorite_followables('Track', 'favorite')

    if @tracks.present?
      render json: @tracks.includes(Consumer.track_eagerload_columns), meta: { count: @tracks.size }, adapter: :json
    else
      render json: { status: "No favorite tracks" }
    end
  end

  def favorited_followed_playlists
    @playlists = params[:type] == 'favorite'? playlists('favorite') : playlists('follow')

    if @playlists.present?
      render json: @playlists , meta: { count: @playlists.size }, adapter: :json
    else
      render json: { status: "No #{params[:type].gsub("follow", "followed")} playlists" }
    end
  end

  def followed_artists
    @followed_artists = current_consumer.favorite_followables('User', 'follow')

    if @followed_artists.present?
      render json: @followed_artists, meta: { count: @followed_artists.size }, adapter: :json
    else
      render json: { status: "No followed artists" }
    end
  end

  private

  def validate_password
    return if current_consumer&.valid_password?(params[:current_password])

    raise ExceptionHandler::AuthenticationError, 'Wrong password'
  end

  def password_params
    params.permit(:password, :password_confirmation)
  end

  def consumer_profile_params
    params.permit(:first_name, :last_name, :email, consumer_profile_attributes: %i[id phone organization address city country
                                                                                   postal_code youtube_url white_listing_enabled])
  end
end
