class Council < ApplicationRecord
  has_many :wards
  has_many :polling_districts, through: :wards
  has_many :polling_stations, through: :wards

  # `transient` flag indicates that a Council is a fake Council just for easy
  # data importing, and should not be displayed or used by default anywhere.
  # XXX This is kind of clunky, improve this somehow.
  default_scope { where(transient: false) }

  validates_presence_of :name
  validates_presence_of :code
end
