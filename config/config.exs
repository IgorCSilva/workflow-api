# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :workflow_api,
  ecto_repos: [WorkflowApi.Repo],
  function_repository: WorkflowApiWeb.Infrastructure.Persistence.FunctionRepositoryPostgres,
  module_repository: WorkflowApiWeb.Infrastructure.Persistence.ModuleRepositoryPostgres,
  sequence_repository: WorkflowApiWeb.Infrastructure.Persistence.SequenceRepositoryPostgres

# Configures the endpoint
config :workflow_api, WorkflowApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Q0sLK4AzAB/ssccBMpl+ezEmxlP7VGpOSG6uIZzGJlY/VS+ituqtewX8wkj66yOA",
  render_errors: [view: WorkflowApiWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: WorkflowApi.PubSub,
  live_view: [signing_salt: "VYtHj8IO"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
