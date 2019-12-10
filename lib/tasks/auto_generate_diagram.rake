# NOTE: only doing this in development as some production environments (Heroku)
# NOTE: are sensitive to local FS writes, and besides -- it's just not proper
# NOTE: to have a dev-mode tool do its thing in production.
# XXX This has stopped auto-generating for some reason - investigate.
if Rails.env.development?
  RailsERD.load_tasks
end
