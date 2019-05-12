
# Null object TurnoutObservation for not yet observed PollingStation.
class UnobservedTurnoutObservation
  def created_at; end

  def count
    0
  end

  def turnout_proportion
    0
  end
end
