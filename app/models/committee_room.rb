class CommitteeRoom < ApplicationRecord
  belongs_to :work_space
  has_many :polling_districts
  has_many :polling_stations, through: :polling_districts
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
        target_district_from(:guesstimated_labour_votes_left)
      when 'warp'
        target_district_from(:remaining_labour_votes_from_warp)
      end

    polling_district&.reference
  end

  private

  def target_district_from(estimated_votes_left_method)
    polling_districts.reject do |pd|
      # Ignore polling districts where estimate by this method is that all
      # Labour promises are still outstanding, implies we have no useful data
      # on these yet and therefore no point highlighting.
      estimated_votes_left = pd.send(estimated_votes_left_method)
      estimated_votes_left == pd.box_labour_promises
    end.max_by(&estimated_votes_left_method)
  end
end
