class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # Record audit log entry for every change to every model.
  audited

  private

  # XXX Maybe this should just be defined (via a concern) for models which use
  # it (Observables?)
  def last_observation_for(observations)
    observations.max_by(&:created_at) || UnobservedObservation.new
  end
end
