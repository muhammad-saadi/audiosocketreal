class Api::V1::AimsApiController < Api::BaseController
  skip_before_action :authenticate_user!, only: %i[track_response]
  skip_before_action :authorize_request, only: %i[track_response]

  def track_response
    byebug
    track_client_id = params[:aims_api][:id_client]
    track = Track.find(track_client_id)
    track.aims_id = params[:aims_api][:id]
    track.aims_status = params[:aims_api][:status]
    track.save!
    byebug
  end
end
