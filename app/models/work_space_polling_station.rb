class WorkSpacePollingStation < ApplicationRecord
  belongs_to :work_space
  belongs_to :polling_station
  belongs_to :committee_room, required: false
  has_one :ward, through: :polling_station
  has_many :turnout_observations

  delegate :reference,
    :name,
    :postcode,
    :fully_specified_name,
    to: :polling_station

  validates_presence_of :box_labour_promises
  validates_presence_of :box_electors

  def as_json(options = {})
    super(options).merge(fully_specified_name: fully_specified_name)
  end

  def colocated_polling_stations
    # Try to merge equivalent postcodes, and reject the polling station we are
    # looking at.
    work_space.work_space_polling_stations.select do |ps|
      ps.id != id && ps.postcode.upcase.gsub(/\s+/, "") == postcode.upcase.gsub(/\s+/, "")
    end
  end

  def last_observation
    turnout_observations.max_by(&:created_at)
  end
end
