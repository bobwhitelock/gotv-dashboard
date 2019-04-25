class Council < ApplicationRecord
  has_many :wards
  has_many :polling_stations, through: :wards
end
