class CommitteeRoomsController < ApplicationController
  layout 'setup'

  def new
    @committee_room = CommitteeRoom.new
    @work_space = find_work_space
    @wards = @work_space.wards
    render layout: 'organiser_dashboard' if params['reconfigure']
  end

  def create
    work_space = find_work_space

    wards = params[:wards]
    work_space_polling_stations = WorkSpacePollingStation.joins(
      :polling_station
    ).where(
      work_space: work_space,
      polling_stations: { ward: wards }
    )

    ActiveRecord::Base.transaction do
      committee_room = CommitteeRoom.create!(
        committee_room_params.merge(work_space: work_space)
      )
      work_space_polling_stations.update_all(committee_room_id: committee_room.id)
    end

    flash.notice = 'Committee room created! You can now create another or continue.'
    redirect_to new_work_space_committee_room_path(work_space)
  end

  private

  def committee_room_params
    params.require(:committee_room).permit(:address, :organiser_name)
  end
end
