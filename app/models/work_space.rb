class WorkSpace < ApplicationRecord
  has_many :wards
  has_many :polling_districts, through: :wards
  has_many :polling_stations, through: :polling_districts
  has_many :committee_rooms
  has_many :turnout_observations, through: :polling_stations
  has_many :remaining_lifts_observations, through: :polling_districts
  has_many :warp_count_observations, through: :polling_districts
  has_many :canvassers_observations, through: :committee_rooms
  has_many :cars_observations, through: :committee_rooms

  accepts_nested_attributes_for :polling_districts

  before_validation :create_identifier, on: :create

  # XXX Introduce nicer way for testing which of these is being used.
  validates :suggested_target_district_method, inclusion: {
    in: ['estimates', 'warp'],
    present: true
  }

  def to_param
    self.identifier
  end

  def polling_stations_by_committee_room
    polling_stations.sort_by do |polling_station|
      # Order polling stations so show within hierarchy order within dashboard
      # - Ward > Polling District > Polling Station/Ballot Box.
      [
        polling_station.ward.name,
        polling_station.polling_district,
        polling_station.reference,
      ]
    end.group_by do |polling_station|
      polling_station.committee_room
    end.sort_by do |committee_room, _|
      if committee_room
        committee_room.organiser_name
      else
        # Ensure 'No committee room' section always last.
        'zzz'
      end
    end
  end

  def polling_districts_by_committee_room
    # XXX add tests for this method. And de-dupe with above? Or can just delete
    # above eventually?
    polling_districts.group_by(&:committee_room).sort_by do |committee_room, _|
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

  # TODO Automatically include any new types of observations here?
  def all_observations
    [
      canvassers_observations,
      cars_observations,
      remaining_lifts_observations,
      turnout_observations,
      warp_count_observations
    ].flatten.sort_by(&:created_at)
  end

  private

  def create_identifier
    self.identifier = self.class.identifier_generator.generate.downcase
  end
end
