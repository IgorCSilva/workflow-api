defmodule WorkflowApiWeb.SequenceController do
  use WorkflowApiWeb, :controller

  alias WorkflowApi.Application.Usecases.ManageSequence
  alias WorkflowApiWeb.ManageErrors

  # Repository
  @sequence_repository Application.get_env(:workflow_api, :sequence_repository)

  def set(conn, params) do
    case ManageSequence.set(params, @sequence_repository) do
      {:ok, sequence} ->
        IO.inspect(sequence)
        conn
        |> put_status(:ok)
        |> render("show.json", %{sequence: sequence})

      {:error, list_errors} ->
        ManageErrors.call(conn, list_errors, :bad_request)
    end
  end

  @doc """
  List all functions.
  """
  def list(conn, _params) do
    case ManageSequence.list(@sequence_repository) do
      sequences ->
        conn
        |> put_status(:ok)
        |> render("index.json", sequences: sequences)
    end
  end
end
