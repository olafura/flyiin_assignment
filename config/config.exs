# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :flyiin_assignment,
  ecto_repos: [FlyiinAssignment.Repo]

# Configures the endpoint
config :flyiin_assignment, FlyiinAssignmentWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ZI4Na56tAofciiGPhSipXPJQUihZ4/GFjGrtJAhzNQu4HjDKGR0J7A3k8AllgeS+",
  render_errors: [view: FlyiinAssignmentWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: FlyiinAssignment.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
