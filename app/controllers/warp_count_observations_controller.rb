class WarpCountObservationsController < ApplicationController
  layout 'organiser_dashboard'

  def index
    @work_space = find_work_space

    @polling_district = PollingDistrict.find(params[:polling_district_id])
    # XXX More ad-hoc authorization, should improve.
    return if @polling_district.work_space != @work_space

    @warp_counts = @polling_district.warp_count_observations.order(created_at: :desc)
    @new_warp_count = WarpCountObservation.new(polling_district: @polling_district)
  end

  def create
    work_space = find_work_space

    # XXX as above
    polling_district = PollingDistrict.find(params[:polling_district_id])
    # XXX More ad-hoc authorization, should improve.
    return if polling_district.work_space != work_space

    # XXX Will this allow updating anyone's WarpCountObservation by modifying
    # the post data?
    WarpCountObservation.create!(create_params)

    redirect_to work_space_polling_district_warp_count_observations_path(
      work_space, polling_district
    )
  end

  def invalidate
    work_space = find_work_space

    # XXX as above
    polling_district = PollingDistrict.find(params[:polling_district_id])
    # XXX More ad-hoc authorization, should improve.
    return if polling_district.work_space != work_space

    warp_count = WarpCountObservation.find_by!(
      polling_district: polling_district,
      id: params[:warp_count_observation_id]
    )
    warp_count.is_valid = false
    warp_count.save!

    redirect_to work_space_polling_district_warp_count_observations_path(
      work_space, polling_district
    )
  end

  private

  def create_params
    params.require(:warp_count_observation).permit(
      :notes, :count, :polling_district_id
    ).merge(
      user: @current_user
    )
  end
end
