class Api::V1::Consumer::FavoritesFollowingController < Api::V1::Consumer::BaseController
  include Api::V1::FavoritesFollowingConcern

  before_action :set_favorite_followable, only: %i[follow unfollow favorite unfavorite]

  def follow
    current_consumer.follow!(@favorite_followable)
    render json: { status: "#{params[:klass].classify} followed" }
  end

  def unfollow
    return render json: { status: "#{params[:klass].classify} unfollowed" } if current_consumer.unfollow!(@favorite_followable)

    raise ExceptionHandler::ValidationError.new(@favorite_followable.errors.to_h, "Error in unfollowing #{params[:klass].classify}.")
  end

  def favorite
    current_consumer.favorite!(@favorite_followable)
    render json: { status: "#{params[:klass].classify} added to favorites" }
  end

  def unfavorite
    return render json: { status: "#{params[:klass].classify} removed from favorites" } if current_consumer.unfavorite!(@favorite_followable)

    raise ExceptionHandler::ValidationError.new(@favorite_followable.errors.to_h, "Error in unfavoriting #{params[:klass].classify}.")
  end

  def favorite_tracks
    @tracks = current_consumer.favorite_followables('Track', 'favorite')

    if @tracks.present?
      render json: @tracks.includes(Track::TRACK_EAGER_LOAD_COLS), meta: { count: @tracks.size }, adapter: :json
    else
      render json: { status: "No favorite tracks" }
    end
  end

  def favorite_sfxes
    @sfxes = current_consumer.favorite_followables('Sfx', 'favorite')

    if @sfxes.present?
      render json: @sfxes.includes(Sfx::SFX_EAGER_LOAD_COLS), meta: { count: @sfxes.size }, adapter: :json
    else
      render json: { status: "No favorite sound affects" }
    end
  end

  def favorited_followed_playlists
    @playlists = current_consumer.playlists(params[:type])

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

  def set_favorite_followable
    @favorite_followable = set_klass(params[:klass]).find(params[:id])
  end
end
