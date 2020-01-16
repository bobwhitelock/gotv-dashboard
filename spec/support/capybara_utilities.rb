
module CapybaraUtilities
  def send_keys(*keys)
    find('body').send_keys(*keys)
  end
end
