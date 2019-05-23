
# Null object TurnoutObservation for not yet observed PollingStation.
class UnobservedTurnoutObservation
  def created_at; end

  def count
    0
  end

  # XXX Need these now?

  def turnout_proportion
    0
  end

  def guesstimated_labour_votes_left
    0
  end
end
