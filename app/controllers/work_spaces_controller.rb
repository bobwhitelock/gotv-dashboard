
require 'open-uri'
require 'json'

# Council = Struct.new(:id, :name, :email)

AvailablePollingStation = Struct.new(:station_id, :address)

class WorkSpacesController < ApplicationController
  layout 'organiser_dashboard'

  def show
    @work_space = WorkSpace.find_by_identifier!(params[:id])
  end

  def start
    @councils = Council.all.sort_by(&:name)
    render layout: 'setup'
  end

  def new
    council = Council.find(params[:council_id])
    @wards = council.wards.sort_by { |w| w.name or 'z' }.compact
    default_name = "#{council.name} #{Time.current.year.to_s} Elections"
    @work_space = WorkSpace.new({ :name => default_name })
    render layout: 'setup'
  end

  def create
    @work_space = WorkSpace.create!(work_space_params)
    @work_space.polling_stations = PollingStation.where(ward_id: params[:wards])
    @work_space.save!

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
