class Ward < ApplicationRecord
  has_many :polling_districts
  has_many :polling_stations, through: :polling_districts

  validates_presence_of :name
  validates_presence_of :code
end
