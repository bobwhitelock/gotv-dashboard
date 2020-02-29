class CommitteeRoom < ApplicationRecord
  belongs_to :work_space
  has_many :polling_stations
  has_many :polling_districts, -> { distinct.order(:reference) }, through: :polling_stations
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
    polling_district = \
      case work_space.suggested_target_district_method
      when 'estimates'
        polling_districts.max_by(&:guesstimated_labour_votes_left)
      when 'warp'
        polling_stations.max_by(&:remaining_labour_votes_from_warp)&.polling_district
      end

    polling_district&.reference
  end
end
