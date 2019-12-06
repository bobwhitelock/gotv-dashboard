
class ConfigurationsController < ApplicationController
  layout 'setup'

  def show
    @work_space = find_work_space
  end

  def update
    work_space = find_work_space
    work_space.update!(update_work_space_params)
    redirect_to work_space_path(work_space)
  end

  private

  def update_work_space_params
    params.require(:work_space).permit(
      work_space_polling_stations_attributes: [
        :id,
        :box_labour_promises,
        :box_electors
      ]
    )
  end
end
