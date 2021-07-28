defmodule WorkflowApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application


  def start(_type, _args) do

    # Criando tabela ets.
    :ets.new(:sequence_operations, [:set, :public, :named_table])
    :ets.new(:sequence_list, [:set, :public, :named_table])

    children = [
      # Start the Ecto repository
      WorkflowApi.Repo,
      # Start the Telemetry supervisor
      WorkflowApiWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: WorkflowApi.PubSub},
      # Start the Endpoint (http/https)
      WorkflowApiWeb.Endpoint
      # Start a worker by calling: WorkflowApi.Worker.start_link(arg)
      # {WorkflowApi.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WorkflowApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    WorkflowApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
