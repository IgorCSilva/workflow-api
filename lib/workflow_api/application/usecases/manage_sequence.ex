defmodule WorkflowApi.Application.Usecases.ManageSequence do

  alias WorkflowApi.Domain.Schemas.{Sequence}
  alias WorkflowApi.Application.Utils.ChangesetErrorsMessage

  def set(params, repository) do
    IO.inspect(params, label: "params")

    formated_sequence = %{
      "name" => params["sequence_name"],
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
    case changeset = Sequence.changeset(formated_sequence) do
      %Ecto.Changeset{:valid? => true} ->
        IO.inspect(changeset)
        repository.set(changeset)

      # Caso ocorra algum erro dentre as validações seu detalhamento é retornado.
      changeset -> {:error, ChangesetErrorsMessage.traverse_message(changeset)}
    end
  end

  def list(repository) do
    repository.list()
  end
end
