class User < ApplicationRecord
  has_many :turnout_observations

  def info
    if name && phone_number
      "#{name} (#{phone_number})"
    elsif name
      "#{name} (phone number unknown)"
    else
      "Volunteer #{id} (name unknown)"
    end
  end
end
