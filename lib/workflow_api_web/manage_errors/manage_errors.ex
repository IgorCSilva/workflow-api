defmodule WorkflowApiWeb.ManageErrors do
  @moduledoc """
  Manage response errors.
  """
  use WorkflowApiWeb, :controller

  alias WorkflowApiWeb.MessageErrorView

  def call(conn, message, status) do
    conn
    |> put_status(status)
    |> put_view(MessageErrorView)
    |> render("message_error.json", %{message_error: message})
  end

  # def call(conn, {:error, :ok}) do
  #   conn
  #   |> put_status(:ok)
  #   |> put_view(MessageErrorView)
  #   |> render(:"404")
  # end
end
