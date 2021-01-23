defmodule WorkflowApi.Application.Utils.GeneralFunctions do
  @moduledoc """
  General functions,
  """

  import Ecto.Changeset


  @doc """
  Verify if string contains only numbers.
  """
  def contains_only_numbers?(info) when is_binary(info) or is_integer(info) do
    case Integer.parse(to_string(info)) do
      {_number, ""} -> true
      _ -> false
    end
  end

  def contains_only_numbers?(_), do: false

  @doc """
  Apply cast_embed to a list of fields.
  """
  def cast_list_embed(changeset, list) do
    Enum.reduce(list, changeset, fn (field, acc) ->
      cast_embed(acc, field)
    end)
  end

  @doc """
  Convert all map key to atoms.
  """
  def map_string_keys_to_atoms(elm) do
    cond do
      is_map(elm) ->
        for {key, val} <- elm, into: %{}, do: {String.to_atom(to_string(key)), map_string_keys_to_atoms(val)}

      is_list(elm) ->
        Enum.map(elm, fn (item) ->
          map_string_keys_to_atoms(item)
        end)

      true -> elm
    end
  end

  @doc """
  Mount a map with all changeset changes.
  """
  def changemap_by_changeset(data) do
    case data do
      %Ecto.Changeset{:changes => changes} ->
        for {key, val} <- changes, into: %{} do

          {key, changemap_by_changeset(val)}
        end

      elm ->
        cond do
          is_map(elm) ->
            for {key, val} <- elm, into: %{} do

              {key, changemap_by_changeset(val)}
            end

          is_list(elm) ->
            Enum.map(elm, fn (item) ->
              changemap_by_changeset(item)
            end)

          true -> elm
        end
    end
  end

  @doc """
  Validate uuid.
  """
  def validate_uuid(changeset, field) do
    validate_change(changeset, field, fn (field, value) ->

      case Ecto.UUID.cast(value) do
        {:ok, _id} -> []
        :error -> [{field, "id inválido."}]
        _ -> [{field, "Something wrong with id."}]
      end
    end)
  end
end
