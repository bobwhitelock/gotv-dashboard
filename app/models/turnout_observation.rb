class TurnoutObservation < ApplicationRecord
  belongs_to :polling_station
  before_validation :default_values

  def default_values
    self.polling_station_id ||= 1
  end
end
