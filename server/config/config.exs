# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :news_diff,
  ecto_repos: [NewsDiff.Repo]

# Configures the endpoint
config :news_diff, NewsDiff.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "VHuM5hptH2wOGTBl4fdSLvgA7IWKBls6JL0X9Aybzn9ts8a/ezSItt5F/lsDTOv2",
  render_errors: [view: NewsDiff.ErrorView, accepts: ~w(html json)],
  pubsub: [name: NewsDiff.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
