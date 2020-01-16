
module CapybaraUtilities
  def body_text
    find('body').text
  end

  def send_keys(*keys)
    find('body').send_keys(*keys)
  end
end
