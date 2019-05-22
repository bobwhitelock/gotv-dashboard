class UsersController < ApplicationController
  def update
    user = User.find(params[:id])

    # Rudimentary authorization.
    if user != @current_user
      redirect_back fallback_location: root_path
      return
    end

    user.update!(user_params)
    flash.notice = 'Your details have been saved. Thanks!'

    # Figure out fallback path as new observation path for work space of one of
    # User's past observations. This will probably break at some point.
    new_observation_path = new_work_space_turnout_observation_path(
      user.turnout_observations.first.work_space
    )

    redirect_back fallback_location: new_observation_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :phone_number)
  end
end
