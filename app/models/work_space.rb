class WorkSpace < ApplicationRecord
  has_and_belongs_to_many :polling_stations
  has_many :turnout_observations

  before_validation :create_identifier, on: :create

  def to_param
    self.identifier
  end

  def latest_observations
    polling_stations.map do |ps|
      most_recent_observation = \
        most_recent_observation_for(ps) || UnobservedTurnoutObservation.new

      OpenStruct.new(
        polling_station: ps,
        turnout_observation: most_recent_observation
      )
    end.sort_by do |o|
      polling_station = o.polling_station

      # Order polling stations consistently by ward name, and then by polling
      # station reference within each ward (if polling stations do not have
      # references set then the name will be used instead, but this should not
      # normally happen).
      [
        polling_station.ward.name,
        polling_station.reference,
        polling_station.name,
      ]
    end
  end

  private

  def create_identifier
    self.identifier = XKPassword.generate.downcase
  end

  def most_recent_observation_for(polling_station)
    self.turnout_observations
      .where(polling_station: polling_station)
      .order(created_at: :desc)
      .limit(1).first
  end
end
