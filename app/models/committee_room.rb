class CommitteeRoom < ApplicationRecord
  belongs_to :work_space
  has_many :work_space_polling_stations
  has_many :canvassers_observations
  has_many :cars_observations

  validates_presence_of :address
  validates_presence_of :organiser_name
end
