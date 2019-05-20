class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # Record audit log entry for every change to every model.
  audited
end
