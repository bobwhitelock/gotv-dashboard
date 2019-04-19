class TurnoutObservation < ApplicationRecord
  belongs_to :polling_station
  belongs_to :work_space
end
