class WorkSpace < ApplicationRecord
  has_and_belongs_to_many :polling_stations
  has_many :turnout_observations
end
