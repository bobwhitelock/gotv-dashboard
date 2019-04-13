
class TurnoutObservationsController < ApplicationController

  def create
    # @observation = TurnoutObservation.create(turnout_params)
    observation = TurnoutObservation.create!(turnout_params)

    redirect_to turnout_observation_path(observation)
  end

  def new
    @observation = TurnoutObservation.new
  end

  private
  def turnout_params
    params.require(:turnout_observation).permit(:count)
  end
end
