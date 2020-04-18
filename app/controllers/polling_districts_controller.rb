class PollingDistrictsController < ApplicationController
  def lifts
    observation_action(RemainingLiftsObservation)
  end

  private

  def observation_action(observation_class)
    polling_district = PollingDistrict.find(params[:polling_district_id])
    observation_action_base(observation_class, polling_district)
  end
end
