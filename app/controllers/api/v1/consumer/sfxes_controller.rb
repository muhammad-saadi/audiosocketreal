class Api::V1::Consumer::SfxesController < Api::V1::Consumer::BaseController
  before_action :set_sfx, only: %i[show add_download_sfx]
  skip_before_action :authenticate_consumer!, only: %i[show index]

  def index
    @sfxes = Sfx.filter(params[:search_key], params[:search_query]).order(params[:order_by]).pagination(pagination_params)
    render json: @sfxes.includes(Sfx::SFX_EAGER_LOAD_COLS), meta: { options: 'sfxes' }, adapter: :json
  end

  def show
    render json: @sfx
  end

  def add_download_sfx
    consumer_medium = ConsumerMedium.download_media(params[:id], @current_consumer, "Sfx")

    if consumer_medium.save!
      render json: { message: "#{@sfx.title} is successfully downloaded"}
    else
       raise ExceptionHandler::ValidationError.new(@current_consumer.errors.to_h, 'Error downloading Sfx.')
    end
  end

  def get_downloaded_sfxes
    download_sfx_list = ConsumerMedium.downloaded_media(@current_consumer.id, 'Sfx')

    if download_sfx_list.present?
      render json: current_consumer.downloaded_sfxes.includes(Sfx::SFX_EAGER_LOAD_COLS)
    else
      render json: { message: "nothing downloaded yet" }
    end
  end

  private

  def set_sfx
    @sfx = Sfx.includes(Sfx::SFX_EAGER_LOAD_COLS).find(params[:id])
  end
end
