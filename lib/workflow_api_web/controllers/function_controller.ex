defmodule WorkflowApiWeb.FunctionController do
  use WorkflowApiWeb, :controller

  alias WorkflowApi.Application.Usecases.ManageFunction
  alias WorkflowApiWeb.ManageErrors

  # Repository
  @function_repository Application.get_env(:workflow_api, :function_repository)

  def create(conn, params) do
    case ManageFunction.create(params, @function_repository) do
      {:ok, function} ->
        conn
        |> put_status(:ok)
        |> render("show.json", %{function: function})

      {:error, list_errors} ->
        ManageErrors.call(conn, list_errors, :bad_request)
    end
  end

  @doc """
  Get function by id.
  """
  def get(conn, %{"id" => id}) do

    case ManageFunction.get(id, @function_repository) do
      {:error, list_errors} ->
        ManageErrors.call(conn, list_errors, :bad_request)

      function ->
        conn
        |> put_status(:ok)
        |> render("show.json", %{function: function})
    end
  end

  @doc """
  List all functions.
  """
  def list(conn, _params) do
    case ManageFunction.list(@function_repository) do
      functions ->
        conn
        |> put_status(:ok)
        |> render("index.json", functions: functions)
    end
  end

  @doc """
  Update function info.
  """
  def update(conn, params) do

    case ManageFunction.update(params, @function_repository) do
      {:ok, function} ->
        conn
        |> put_status(:ok)
        |> render("show.json", %{function: function})

      {:error, list_errors} ->
        ManageErrors.call(conn, list_errors, :bad_request)
    end

  end
end
