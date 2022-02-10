class Api::V1::Consumer::SfxesController < Api::V1::Consumer::BaseController
  before_action :set_sfx, only: :show
  skip_before_action :authenticate_consumer!, only: %i[show index]

  def index
    @sfxes = Sfx.search(params)
    @favorite_sfx_ids = current_consumer&.favorite_followables('Sfx', 'favorite')&.ids

    render json: @sfxes.pagination(pagination_params), meta: { total_sfx_count: @sfxes.size, favorite_sfx_ids: @favorite_sfx_ids, options: 'sfxes' }, adapter: :json
  end

  def show
    render json: @sfx
  end

  private

  def set_sfx
    @sfx = Sfx.includes(Sfx::SFX_EAGER_LOAD_COLS).find(params[:id])
  end
end
