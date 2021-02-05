defmodule WorkflowApi.Repo do
  use Ecto.Repo,
    otp_app: :workflow_api,
    adapter: Ecto.Adapters.Postgres
end
