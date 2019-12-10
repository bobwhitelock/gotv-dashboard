class WarpCountObservationsController < ApplicationController
  layout 'organiser_dashboard'

  def index
    @work_space = find_work_space

    # XXX Using WSPS as PollingDistrict proxy again here, and so finding by
    # 'PollingDistrict' ID (which will actually be WSPS ID). Move things to
    # PollingDistrict level and remove this hack from all over.
    polling_station = WorkSpacePollingStation.find(params[:polling_district_id])
    # XXX More ad-hoc authorization, should improve.
    return if polling_station.work_space != @work_space

    @polling_district = polling_station.polling_district
    @warp_counts = polling_station.warp_count_observations.order(created_at: :desc)
    @new_warp_count = WarpCountObservation.new(work_space_polling_station: polling_station)
  end

  def create
    work_space = find_work_space

    # XXX as above
    polling_station = WorkSpacePollingStation.find(params[:polling_district_id])
    # XXX More ad-hoc authorization, should improve.
    return if polling_station.work_space != work_space

    # XXX Will this allow updating anyone's WarpCountObservation by modifying
    # the post data?
    WarpCountObservation.create!(create_params)

    redirect_to work_space_polling_district_warp_count_observations_path(
      work_space, polling_station
    )
  end

  private

  def create_params
    params.require(:warp_count_observation).permit(
      :notes, :count, :work_space_polling_station_id
    ).merge(
      user: @current_user
    )
  end
end
