
module CapybaraUtilities
  def send_keys(*keys)
    find('body').send_keys(*keys)
  end

  # Find element with given `value` for `data-test` attribute (these attributes
  # are intended only for finding elements in tests), relative to element
  # passed as `root` (defaulting to entire page).
  def find_data_test(value, root: page)
    root.find("[data-test=\"#{value}\"]")
  end
end
