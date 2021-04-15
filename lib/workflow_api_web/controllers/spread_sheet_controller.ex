defmodule WorkflowApiWeb.SpreadSheetController do
  use WorkflowApiWeb, :controller

  alias WorkflowApi.Application.Usecases.ManageSheet

  @doc """
  Read data from spreadsheet.
  """
  def read(conn, params) do
    case ManageSheet.read(params) do
      {:ok,  response} ->
        conn
        |> put_status(:ok)
        |> json(%{data: response})

      {:error, message_error} ->
        conn
        |> put_status(:bad_request)
        |> json(%{errors: message_error})
    end
  end

  @doc """
  Append data in spreadsheet.
  """
  def append(conn, params) do
    case ManageSheet.append(params) do
      {:ok,  updates} ->
        conn
        |> put_status(:ok)
        |> render("append_updates.json", %{spread_sheet: updates})

      {:error, message_error} ->
        conn
        |> put_status(:bad_request)
        |> json(%{errors: message_error})
    end
  end
end
