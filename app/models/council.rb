class Council < ApplicationRecord
  has_many :wards
  has_many :polling_stations, through: :wards

  validates_presence_of :name
  validates_presence_of :code
end
