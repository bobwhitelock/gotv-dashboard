class WorkSpace < ApplicationRecord
  def to_param
    name.parameterize
  end
end
