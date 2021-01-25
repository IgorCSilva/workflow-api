defmodule WorkflowApi.Application.Usecases.ManageSequence do

  alias WorkflowApi.Domain.Schemas.{Sequence}
  alias WorkflowApi.Application.Utils.ChangesetErrorsMessage

  def create(params, repository) do
    IO.inspect(params, label: "params")

    formated_sequence = %{
      "name" => params["name"],
      "blocks" => Enum.map(params["sequence"], fn block ->
        %{
          "workflow_block_id" => block["id"],
          "workflow_block_pos_x" => block["x"],
          "workflow_block_pos_y" => block["y"],
          "function_id" => block["functionId"],
        }
      end),
      "links" => Enum.map(params["links"], fn link ->
        %{
          "workflow_link_id" => link["id"],
          "from" => link["from"],
          "to" => link["to"]
        }
      end)
    }

    IO.inspect(formated_sequence)
    # Verificando se os dados fornecidos em params são válidos.
    case changeset = Sequence.changeset(%Sequence{}, formated_sequence) do
      %Ecto.Changeset{:valid? => true} ->
        IO.inspect(changeset)
        repository.create(changeset)


      # Caso ocorra algum erro dentre as validações seu detalhamento é retornado.
      changeset -> {:error, ChangesetErrorsMessage.traverse_message(changeset)}
    end
  end

  def list(repository) do
    repository.list()
  end

  @doc """
  Update sequence info or return associated error to the
  wrong data.
  """
  def update(params, repository) do

    formated_sequence = %{
      "blocks" => Enum.map(params["sequence"], fn block ->
        %{
          "workflow_block_id" => block["id"],
          "workflow_block_pos_x" => block["x"],
          "workflow_block_pos_y" => block["y"],
          "function_id" => block["functionId"],
        }
      end),
      "links" => Enum.map(params["links"], fn link ->
        %{
          "workflow_link_id" => link["id"],
          "from" => link["from"],
          "to" => link["to"]
        }
      end)
    }

    IO.inspect(formated_sequence)
    {:ok, sid} = Map.fetch(params, "id")
    IO.inspect(repository.get(sid))

    with {:ok, sequence_id} <- Map.fetch(params, "id"),
      # {:uuid, {:ok, id}} <- {:uuid, Ecto.UUID.cast(sequence_id)},
      sequence <- repository.get(sequence_id),
      {:is_nil, false} <- {:is_nil, is_nil(sequence)},
      changeset <- Sequence.changeset(sequence, Map.put(formated_sequence, "name", sequence.name)),
      %Ecto.Changeset{:valid? => true} <- changeset do

        IO.inspect(changeset)
        # Atualizando informações.
        case repository.update(changeset) do
          {:ok, sequence} ->
            IO.inspect(sequence)
            {:ok, sequence}

          {:error, changeset_update} ->
            {:error, ChangesetErrorsMessage.traverse_message(changeset_update)}
        end
    else
      :error -> {:error, "The sequence id was not sent."}
      {:uuid, :error} -> {:error, "Invalid id."}
      {:is_nil, true} -> {:error, "There isn't sequence with this id."}

      {:error, changeset} ->
        {:error, ChangesetErrorsMessage.traverse_message(changeset)}

      changeset ->
        {:error, ChangesetErrorsMessage.traverse_message(changeset)}
    end

  end

  @doc """
  Delete service by id or return error if we receive an invalid id.
  """
  def delete(id, repository) do

    with {:ok, id} <- Ecto.UUID.cast(id) do
      case repository.get(id) do
        nil -> {:error, "There isn't sequence with this id."}

        sequence -> repository.delete(sequence)
      end
    else
      :error -> {:error, "Invalid id."}
    end
  end
end
