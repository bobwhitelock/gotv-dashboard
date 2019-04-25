
class TurnoutObservationsController < ApplicationController

  def create
    observation = TurnoutObservation.create!(turnout_params)

    redirect_to work_space_turnout_observation_path(observation.work_space, observation)
  end

  def new
    @work_space = find_work_space
    @polling_stations = @work_space.polling_stations.sort_by(&:name)
    @observation = TurnoutObservation.new
    @observation.work_space = @work_space
  end

  def show
    @observation = TurnoutObservation.find(params[:id])
    @work_space = @observation.work_space
  end

  def index
    @work_space = find_work_space
    @observations = @work_space.turnout_observations
  end

  private

  def turnout_params
    params.require(:turnout_observation).permit(
      [:count, :polling_station_id]
    ).merge(
      # `work_space_id` is the foreign key but we use the `identifier` for the
      # WorkSpace in the URL (for secure obfuscation), therefore find the
      # WorkSpace from the `identifier` and then merge in the `id` for this
      # instead.
      work_space_id: find_work_space.id
    )
  end

  def find_work_space
    WorkSpace.find_by_identifier!(params[:work_space_id])
  end
end
