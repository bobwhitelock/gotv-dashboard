class ApplicationController < ActionController::Base
  before_action :assign_current_user

  private

  CURRENT_USER_ID_KEY = 'current_user_id'.freeze

  def assign_current_user
    # Current User is currently coupled to cookie => delete the cookie and you
    # become a new User ¯\_(ツ)_/¯.
    current_user_id = session[CURRENT_USER_ID_KEY]
    @current_user = User.find_or_create_by(id: current_user_id)
    session[CURRENT_USER_ID_KEY] = @current_user.id
  end
end
