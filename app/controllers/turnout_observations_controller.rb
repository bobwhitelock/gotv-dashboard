
class TurnoutObservationsController < ApplicationController
  layout 'roaming'

  def start
    @work_space = find_work_space
    @polling_stations = @work_space.polling_stations.sort_by(&:reference)
  end

  def new
    @work_space = find_work_space
    polling_station = @work_space.polling_stations.find(
      params[:polling_station]
    )
    @observation = TurnoutObservation.new(
      polling_station: polling_station
    )
  end

  def create
    work_space = find_work_space

    observation = TurnoutObservation.new(create_observation_params)
    # XXX Ad-hoc checking to prevent creating observations for other WorkSpaces
    # - make this better and happen for all actions.
    observation.save! if observation.work_space == work_space

    redirect_to work_space_turnout_observation_path(observation.work_space, observation)
  end

  def show
    @observation = TurnoutObservation.find(params[:id])
    @work_space = @observation.work_space
  end

  def index
    @work_space = find_work_space
    @observations = @work_space.turnout_observations.order(created_at: :desc)
    render layout: 'organiser_dashboard'
  end

  def edit
    @work_space = find_work_space
    # XXX This (and similar code in `update`) will allow editing observation
    # for any workspace by editing URL - prevent this.
    @observation = TurnoutObservation.find(params[:id])
    render layout: 'organiser_dashboard'
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
      user: @current_user
    )
  end

  def update_observation_params
    params.require(:turnout_observation).permit(:count)
  end
end
