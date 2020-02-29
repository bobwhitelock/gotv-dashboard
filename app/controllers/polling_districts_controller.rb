class PollingDistrictsController < ApplicationController
  def lifts
    observation_action(RemainingLiftsObservation)
  end

  private

  def observation_action(observation_class)
    # XXX Using WSPS as PollingDistrict proxy again here, and so finding by
    # 'PollingDistrict' ID (which will actually be WSPS ID). Move things to
    # PollingDistrict level and remove this hack from all over.
    polling_station = WorkSpacePollingStation.find(params[:polling_district_id])

    observation_action_base(observation_class, polling_station)
  end
end
