class ApplicationController < ActionController::Base
  before_action :assign_current_user

  private

  CURRENT_USER_ID_KEY = 'current_user_id'.freeze

  def assign_current_user
    # Current User is currently coupled to cookie => delete the cookie and you
    # become a new User ¯\_(ツ)_/¯.
    current_user_id = session[CURRENT_USER_ID_KEY]

    if current_user_id
      @current_user = User.find(current_user_id)
    else
      @current_user = User.create!
      # XXX Is there a potential security issue here? Can session value be
      # manipulated client-side to allow people to pretend to be someone else?
      session[CURRENT_USER_ID_KEY] = @current_user.id
    end
  end

  def find_work_space
    WorkSpace.find_by_identifier!(params[:work_space_id])
  end
end
