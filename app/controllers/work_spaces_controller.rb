
require 'open-uri'
require 'json'

AvailablePollingStation = Struct.new(:station_id, :address)

class WorkSpacesController < ApplicationController
  layout 'organiser_dashboard'

  def show
    @work_space = WorkSpace.find_by_identifier!(params[:id])
  end

  def create
    ActiveRecord::Base.transaction do
      @work_space = WorkSpace.create!(create_work_space_params)

      wards = params[:wards]
      polling_stations = PollingStation.where(ward_id: wards)
      polling_stations.each do |ps|
        @work_space.work_space_polling_stations.create!(
          polling_station: ps,
          box_labour_promises: 0,
          box_electors: 0
        )
      end
    end

    redirect_to new_work_space_committee_room_path(@work_space)
  end

  # XXX Adapted from above, with stuff pulled in from `gotv:randomize_figures`
  # Rake task. Probably don't need this and above, maybe just get rid of most
  # of above setup process.
  def demo
    ActiveRecord::Base.transaction do
      @work_space = WorkSpace.create!(
        name: 'Ilford North General Election 2019 [demo]'
      )

      wards = ilford_north_wards
      polling_stations = PollingStation.where(ward_id: wards)
      polling_stations.each do |ps|

        box_electors = rand(500..3000)
        minimum_box_promises = box_electors / 3
        maximum_box_promises = box_electors * 2/3
        box_labour_promises = rand(minimum_box_promises..maximum_box_promises)

        postal_electors = rand(50..300)
        minimum_postal_promises = postal_electors / 3
        maximum_postal_promises = postal_electors * 2/3
        postal_labour_promises = rand(minimum_postal_promises..maximum_postal_promises)

        @work_space.work_space_polling_stations.create!(
          polling_station: ps,

          box_labour_promises: box_labour_promises,
          box_electors: box_electors,

          postal_labour_promises: postal_labour_promises,
          postal_electors: postal_electors
        )
      end
    end

    redirect_to work_space_path(@work_space)
  end

  def update
    work_space = WorkSpace.find_by_identifier!(params[:id])
    work_space.update!(update_work_space_params)
    redirect_to work_space_path(work_space)
  end

  private

  def create_work_space_params
    params.require(:work_space).permit(:name)
  end

  def update_work_space_params
    params.require(:work_space).permit(:suggested_target_district_method)
  end

  def ilford_north_wards
    [
      'Aldborough',
      'Barkingside',
      'Bridge',
      'Clayhall',
      'Fairlop',
      'Fullwell',
      'Hainault',
      # Roding isn't in our Redbridge data set, for some reason.
      # 'Roding'
    ].map do |name|
      Ward.find_by!(name: name)
    end
  end

  # XXX Load and cache this and `council_ids_with_polling_stations`, rather
  # than on every request and risk things breaking if API is temporarily
  # unavailable.
  # XXX None of this is used any more - remove or adapt.
  def councils
    data = wheredoivote_data 'councils'
    data.map do |council_data|
      Council.new(
        council_data['council_id'],
        council_data['name'],
        council_data['email']
      )
    end.reject { |c| c.name.empty? }.sort_by(&:name)
  end

  def council_ids_with_polling_stations
    data = wheredoivote_data 'pollingstations'
    available_councils_with_polling_stations = \
      data['results'].group_by do |polling_stations|
      polling_stations['council']
    end.map do |council_url, council_ps|
      [
        File.basename(council_url, '.*'),
        council_ps.map do |ps|
          AvailablePollingStation.new(ps['station_id'], ps['address'])
        end
      ]
    end.to_h
    Hash.new([]).merge(available_councils_with_polling_stations)
  end

  def wheredoivote_data(endpoint)
    endpoint_url = "https://wheredoivote.co.uk/api/beta/#{endpoint}.json"
    data = open(endpoint_url).read
    return JSON.parse(data)
  end
end
