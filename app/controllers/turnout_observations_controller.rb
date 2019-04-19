
class TurnoutObservationsController < ApplicationController

  def create
    observation = TurnoutObservation.create!(turnout_params)

    redirect_to turnout_observation_path(observation)
  end

  def new
    @work_space = WorkSpace.find(params[:work_space_id])
    @polling_stations = @work_space.polling_stations.sort_by {|station| station.name}
    @observation = TurnoutObservation.new
    @observation.work_space = @work_space
  end

  def show
    @observation = TurnoutObservation.find(params[:id])
    @work_space = @observation.work_space
  end

  def index
    @work_space = WorkSpace.find(params[:work_space_id])

    @observations = @work_space.turnout_observations
  end

  private
  def turnout_params
    request_params = params.permit(:work_space_id, :turnout_observation => [ :count, :polling_station_id])
    private_params = {:work_space_id => request_params[:work_space_id]} # get this from the session
    request_params[:turnout_observation].merge(private_params)
  end
end
