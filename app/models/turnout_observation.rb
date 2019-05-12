class TurnoutObservation < ApplicationRecord
  belongs_to :polling_station
  belongs_to :work_space

  def turnout_proportion
    registered_voters = polling_station.pre_election_registered_voters
    if registered_voters > 0
      self.count.to_f / registered_voters
    else
      0
    end
  end
end
