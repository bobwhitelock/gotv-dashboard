class Council < ApplicationRecord
  has_many :polling_stations
  has_many :wards
end
