
require 'open-uri'
require 'json'

AvailablePollingStation = Struct.new(:station_id, :address)

class WorkSpacesController < ApplicationController
  def show
    @work_space = WorkSpace.find(params[:id])
  end

  def new
    @work_space = WorkSpace.new
    @councils = councils_with_polling_stations
  end

  def create
    @work_space = WorkSpace.create!(work_space_params)

    council_polling_stations = councils_with_polling_stations[params[:council]]
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

  def councils_with_polling_stations
    data = open('https://wheredoivote.co.uk/api/beta/pollingstations.json').read
    json = JSON.parse(data)
    json['results'].group_by do |polling_stations|
      polling_stations['council']
    end.map do |council_url, council_ps|
      [
        File.basename(council_url, '.*'),
        council_ps.map do |ps|
          AvailablePollingStation.new(ps['station_id'], ps['address'])
        end
      ]
    end.to_h
  end
end
