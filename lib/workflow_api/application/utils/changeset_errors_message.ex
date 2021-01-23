defmodule WorkflowApi.Application.Utils.ChangesetErrorsMessage do
  @moduledoc """
  Manage changeset errors to return them in friendly format.
  """

  import Ecto.Changeset

  @doc """
  Return changeset errors as list of maps.
  """
  def traverse_message(changeset) do
    traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->

        if is_list(value) and is_atom(Enum.at(value, 0)) do
          acc
        else
          String.replace(acc, "%{#{key}}", to_string(value))
        end

      end)
    end)
  end

  @doc """
  Return an error tuple with changeset errors as list of maps.
  """
  def error_tuple_traverse_message(changeset) do
    {:error, traverse_message(changeset)}
  end
end
