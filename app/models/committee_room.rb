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

  # XXX This and its usage is kind of hacky, involves duplicate data loading
  # etc.
  def suggested_target_district_reference
    wsps, _ = work_space_polling_stations.map do |wsps|
      [wsps, wsps.last_observation]
    end.to_h.reject do |_, o|
      o.nil?
    end.max_by do |_, o|
      o.guesstimated_labour_votes_left
    end

    wsps&.polling_district&.reference
  end

  private

  def last_observation_for(observations)
    observations.max_by(&:created_at) || UnobservedCommitteeRoomObservation.new
  end
end
