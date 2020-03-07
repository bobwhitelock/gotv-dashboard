class ApplicationController < ActionController::Base
  # Order is important here.
  before_action :assign_current_user
  before_action :set_raven_context

  private

  CURRENT_USER_ID_KEY = 'current_user_id'.freeze

  def assign_current_user
    # Current User is currently coupled to cookie => delete the cookie and you
    # become a new User ¯\_(ツ)_/¯.
    current_user_id = session[CURRENT_USER_ID_KEY]

    @current_user = User.find_by(id: current_user_id)
    unless @current_user
      @current_user = User.create!
      # XXX Is there a potential security issue here? Can session value be
      # manipulated client-side to allow people to pretend to be someone else?
      session[CURRENT_USER_ID_KEY] = @current_user.id
    end
  end

  def set_raven_context
    Raven.user_context(
      id: @current_user.id,
      name: @current_user.name,
      phone_number: @current_user.phone_number
    )
  end

  def find_work_space
    WorkSpace.find_by_identifier!(params[:work_space_id])
  end

  def observation_action_base(observation_class, observed_on)
    # XXX More ad-hoc authorization, should improve.
    return if observed_on.work_space != find_work_space

    observation_class.create!(
      observation_class.observed_for => observed_on,
      count: params[:count],
      user: @current_user
    )
  end

end
