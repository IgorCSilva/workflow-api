defmodule WorkflowApiWeb.Infrastructure.Persistence.SequenceRepositoryPostgres do

  import Ecto.Query

  alias WorkflowApi.Repo
  alias WorkflowApi.Domain.Schemas.Sequence
  alias WorkflowApi.Domain.Repositories.{ISequenceRepository}
  alias WorkflowApi.Application.Utils.ChangesetErrorsMessage

  @behaviour ISequenceRepository

  @doc """
  Cria uma função a partir de um changeset.
  Caso ocorra algum erro o mesmo é detalhado.
  """
  @impl ISequenceRepository
  def set(sequence_changeset) do
    # Tenta inserir a função no banco de dados.
    case Repo.insert(sequence_changeset) do
      {:ok, sequence} -> {:ok, sequence}

      {:error, changeset} -> ChangesetErrorsMessage.error_tuple_traverse_message(changeset)
    end
  end

  @doc """
  Retorna todas as funções.
  """
  @impl ISequenceRepository
  def list do
    Repo.all(from Sequence)
  end

end
