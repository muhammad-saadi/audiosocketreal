class Api::V1::Consumer::SfxesController < Api::V1::Consumer::BaseController
  before_action :set_sfx, only: %i[show]
  skip_before_action :authenticate_consumer!, only: %i[show index]

  def index
    @sfxes = Sfx.filter(params[:search_key], params[:search_query]).order(params[:order_by]).pagination(pagination_params)
    render json: @sfxes.includes(Sfx::SFX_EAGER_LOAD_COLS), meta: { options: 'sfxes' }, adapter: :json
  end

  def show
    render json: @sfx
  end

  private

  def set_sfx
    @sfx = Sfx.includes(Sfx::SFX_EAGER_LOAD_COLS).find(params[:id])
  end
end
