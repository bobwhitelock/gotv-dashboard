class PollingDistrict < ApplicationRecord
  belongs_to :ward
  has_many :polling_stations

  validates_presence_of :reference
end
