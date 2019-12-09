class PagesController < ApplicationController
  layout 'marketing'

  # XXX Remove this at some point.
  def test_sentry
    raise 'Testing Sentry'
  end
end
