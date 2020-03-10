class Ward < ApplicationRecord
  belongs_to :work_space
  has_many :polling_districts
  has_many :polling_stations, through: :polling_districts

  validates_presence_of :name
end
