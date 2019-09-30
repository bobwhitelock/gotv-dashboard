class Ward < ApplicationRecord
  has_many :polling_stations
  belongs_to :council

  validates_presence_of :name
  validates_presence_of :code
end
