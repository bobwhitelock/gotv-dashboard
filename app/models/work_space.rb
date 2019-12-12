class WorkSpace < ApplicationRecord
  has_many :work_space_polling_stations
  has_many :committee_rooms
  has_many :turnout_observations, through: :work_space_polling_stations
  has_many :warp_count_observations, through: :work_space_polling_stations
  has_many :polling_stations, through: :work_space_polling_stations
  has_many :wards, -> { distinct.order(:name) }, through: :polling_stations
  has_many :polling_districts, -> { distinct.order(:reference) }, through: :polling_stations

  accepts_nested_attributes_for :work_space_polling_stations

  before_validation :create_identifier, on: :create

  # XXX Introduce nicer way for testing which of these is being used.
  validates :suggested_target_district_method, inclusion: {
    in: ['estimates', 'warp'],
    present: true
  }

  def to_param
    self.identifier
  end

  def latest_observations_by_committee_room
    work_space_polling_stations.map do |ps|
      most_recent_observation = \
        most_recent_observation_for(ps) || UnobservedTurnoutObservation.new

      OpenStruct.new(
        polling_station: ps,
        turnout_observation: most_recent_observation
      )
    end.sort_by do |o|
      polling_station = o.polling_station

      # Order polling stations so show within hierarchy order within dashboard
      # - Ward > Polling District > Polling Station/Ballot Box.
      [
        polling_station.ward.name,
        polling_station.polling_district,
        polling_station.reference,
      ]
    end.group_by do |o|
      o.polling_station.committee_room
    end.sort_by do |committee_room, _|
      if committee_room
        committee_room.organiser_name
      else
        # Ensure 'No committee room' section always last.
        'zzz'
      end
    end
  end

  def self.identifier_generator
    @identifier_generator ||= XKPassword::Generator.new
  end

  private

  def create_identifier
    self.identifier = self.class.identifier_generator.generate.downcase
  end

  # XXX Make this a method on WorkSpacePollingStation?
  def most_recent_observation_for(work_space_polling_station)
    work_space_polling_station.turnout_observations
      .order(created_at: :desc)
      .limit(1).first
  end
end
