
require 'open-uri'
require 'json'

Council = Struct.new(:id, :name, :email)

AvailablePollingStation = Struct.new(:station_id, :address)

class WorkSpacesController < ApplicationController
  def show
    @work_space = WorkSpace.find(params[:id])
  end

  def new
    @work_space = WorkSpace.new
    @councils = councils
  end

  def create
    @work_space = WorkSpace.create!(work_space_params)

    council_polling_stations = council_ids_with_polling_stations[params[:council]]
    council_polling_stations.each do |ps|
      PollingStation.create!(
        work_space: @work_space,
        name: ps[:address],
        # XXX Make these use real figures.
        pre_election_registered_voters: 0,
        pre_election_labour_promises: 0
      )
    end

    redirect_to @work_space
  end

  private

  def work_space_params
    params.require(:work_space).permit(:name)
  end

  # XXX Load and cache this and `council_ids_with_polling_stations`, rather
  # than on every request and risk things breaking if API is temporarily
  # unavailable.
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
