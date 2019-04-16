
class TurnoutObservationsController < ApplicationController

  def create
    observation = TurnoutObservation.create!(turnout_params)

    redirect_to turnout_observation_path(observation)
  end

  def new
    @work_space = WorkSpace.find(params[:work_space_id])
    @observation = TurnoutObservation.new
  end

  def show
    @observation = TurnoutObservation.find(params[:id])
    @work_space = @observation.polling_station.work_space
  end

  private
  def turnout_params
    params
        .require(:turnout_observation)
        .permit(:count,:polling_station, :work_space_id)
  end
end
