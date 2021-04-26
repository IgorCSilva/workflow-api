defmodule WorkflowApiWeb.DemoAppController do
  use WorkflowApiWeb, :controller

  alias WorkflowApi.Application.Usecases.ManageDemoApp
  alias WorkflowApiWeb.ManageErrors

  # Repository
  @sequence_repository Application.get_env(:workflow_api, :sequence_repository)
  @function_repository Application.get_env(:workflow_api, :function_repository)

  def register_client(conn, params) do
    case ManageDemoApp.register_client(params, @sequence_repository, @function_repository) do
      {:ok, result} ->
        conn
        |> put_status(:ok)
        |> render("show.json", %{client: result})

      {:error, list_errors} ->
        ManageErrors.call(conn, list_errors, :bad_request)
    end
  end
end
