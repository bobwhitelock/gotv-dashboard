class Ward < ApplicationRecord
  has_many :polling_stations
  belongs_to :council
end
