defmodule WorkflowApi.Application.Usecases.ManageFunction do

  alias WorkflowApi.Domain.Schemas.Function
  alias WorkflowApi.Application.Utils.ChangesetErrorsMessage

  def create(params, repository) do
    # Verificando se os dados fornecidos em params são válidos.
    case changeset = Function.changeset(params) do
      # Se passar pelas validações o changeset é enviado para a criação da função.
      %Ecto.Changeset{:valid? => true} ->
        # IO.inspect(changeset)
        # Tenta inserir a função no banco de dados.
        repository.create(changeset)

      # Caso ocorra algum erro dentre as validações seu detalhamento é retornado.
      changeset -> {:error, ChangesetErrorsMessage.traverse_message(changeset)}
    end
  end

  def list(repository) do
    repository.list()
  end
end
