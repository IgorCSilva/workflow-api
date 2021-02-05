defmodule WorkflowApiWeb.ModuleController do
  use WorkflowApiWeb, :controller

  alias WorkflowApi.Application.Usecases.ManageModule
  alias WorkflowApiWeb.ManageErrors

  # Repository
  @function_repository Application.get_env(:workflow_api, :function_repository)
  @module_repository Application.get_env(:workflow_api, :module_repository)

  def create(conn, params) do
    case ManageModule.create(params, @module_repository, @function_repository) do
      {:ok, module} ->
        IO.inspect(module)
        conn
        |> put_status(:ok)
        |> render("show.json", %{module: module})

      {:error, list_errors} ->
        ManageErrors.call(conn, list_errors, :bad_request)
    end
  end

  @doc """
  List all functions.
  """
  def list(conn, _params) do
    case ManageModule.list(@module_repository) do
      modules ->
        IO.inspect(modules)
        conn
        |> put_status(:ok)
        |> render("index.json", modules: modules)
    end
  end

  @doc """
  Update module's function, adding, removing or replacing them.
  """
  def update_functions(conn, params) do
    IO.inspect(params)
    case ManageModule.update_functions(params, @module_repository) do
      {:ok, module} ->
        IO.inspect(module)
        conn
        |> put_status(:ok)
        |> render("show.json", %{module: module})

      {:error, list_errors} ->
        ManageErrors.call(conn, list_errors, :bad_request)
    end
  end
end
