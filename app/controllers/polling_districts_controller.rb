class PollingDistrictsController < ApplicationController
  def lifts
    observation_action(RemainingLiftsObservation)
  end

  private

  # XXX Copied and tweaked from
  # `CommitteeRoomsController#volunteers_observation_action` - DRY up.
  def observation_action(observation_class)
    # XXX Using WSPS as PollingDistrict proxy again here, and so finding by
    # 'PollingDistrict' ID (which will actually be WSPS ID). Move things to
    # PollingDistrict level and remove this hack from all over.
    polling_station = WorkSpacePollingStation.find(params[:polling_district_id])
    # XXX More ad-hoc authorization, should improve.
    return if polling_station.work_space != find_work_space

    observation_class.create!(
      work_space_polling_station: polling_station,
      count: params[:count],
      user: @current_user
    )
  end
end
