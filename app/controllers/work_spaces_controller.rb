
class WorkSpacesController < ApplicationController
  layout 'organiser_dashboard'

  def show
    @work_space = WorkSpace.find_by_identifier!(params[:id])
  end

  def demo
    polling_stations_csv = File.read('example_data/polling_stations.csv')
    campaign_stats_csv = File.read('example_data/campaign_stats.csv')

    work_space = ContactCreatorImporter.import(
      work_space_name: "Vauxhall Election #{Time.zone.now.year} [Demo]",
      polling_stations_csv: polling_stations_csv,
      campaign_stats_csv: campaign_stats_csv
    )

    redirect_to work_space_path(work_space)
  end

  def update
    work_space = WorkSpace.find_by_identifier!(params[:id])
    work_space.update!(update_work_space_params)
    redirect_to work_space_path(work_space)
  end

  private

  def update_work_space_params
    params.require(:work_space).permit(:suggested_target_district_method)
  end
end
