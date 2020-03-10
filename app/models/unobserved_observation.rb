
# Null object for all Observations.
class UnobservedObservation
  # XXX checked in several places to see if this is a real observation (nil =>
  # it isn't) - maybe switch to a more obvious way of doing this.
  def created_at; end

  def count
    0
  end
end
