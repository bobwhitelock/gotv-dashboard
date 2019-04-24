class WorkSpace < ApplicationRecord
  has_and_belongs_to_many :polling_stations
  has_many :turnout_observations

  before_validation :create_identifier, on: :create

  def to_param
    self.identifier
  end

  private

  def create_identifier
    self.identifier = XKPassword.generate.downcase
  end
end
