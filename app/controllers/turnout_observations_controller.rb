
class TurnoutObservationsController < ApplicationController

  def create
    observation = TurnoutObservation.create!(create_observation_params)

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

  def edit
    @work_space = find_work_space
    # XXX This (and similar code in `update`) will allow editing observation
    # for any work space by editing URL - prevent this.
    @observation = TurnoutObservation.find(params[:id])
  end

  def update
    @work_space = find_work_space
    @observation = TurnoutObservation.find(params[:id])
    @observation.update!(update_observation_params)
    redirect_to work_space_turnout_observations_path(@work_space)
  end

  private

  def create_observation_params
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

  def update_observation_params
    params.require(:turnout_observation).permit(:count)
  end

  def find_work_space
    WorkSpace.find_by_identifier!(params[:work_space_id])
  end
end
