class CommitteeRoom < ApplicationRecord
  belongs_to :work_space
  has_many :work_space_polling_stations
  has_many :canvassers_observations
  has_many :cars_observations

  validates_presence_of :address
  validates_presence_of :organiser_name

  def last_canvassers_observation
    last_observation_for(canvassers_observations)
  end

  def last_cars_observation
    last_observation_for(cars_observations)
  end

  private

  def last_observation_for(observations)
    observations.max_by(&:created_at) || UnobservedCommitteeRoomObservation.new
  end
end
