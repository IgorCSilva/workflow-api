defmodule WorkflowApiWeb.Infrastructure.Persistence.SequenceRepositoryPostgres do

  import Ecto.Query

  alias WorkflowApi.Repo
  alias WorkflowApi.Domain.Schemas.Sequence
  alias WorkflowApi.Domain.Repositories.{ISequenceRepository}
  alias WorkflowApi.Application.Utils.ChangesetErrorsMessage

  @behaviour ISequenceRepository

  # @impl ISequenceRepository
  # def from_query_exists?(query) do
  #   Repo.exists?(query)
  # end

  @doc """
  Cria uma sequência a partir de um changeset.
  Caso ocorra algum erro o mesmo é detalhado.
  """
  @impl ISequenceRepository
  def create(sequence_changeset) do
    # Tenta inserir a função no banco de dados.
    case Repo.insert(sequence_changeset) do
      {:ok, sequence} -> {:ok, sequence}

      {:error, changeset} -> ChangesetErrorsMessage.error_tuple_traverse_message(changeset)
    end
  end

  @doc """
  Retorna um serviço.
  """
  @impl ISequenceRepository
  def get(id) do
    Repo.get(Sequence, id)
  end

  @doc """
  Retorna todas as funções.
  """
  @impl ISequenceRepository
  def list do
    Repo.all(from Sequence)
  end

  @doc """
  Buscando sequência pelo nome.
  """
  @impl ISequenceRepository
  def get_by_name(name) do
    Repo.get_by(Sequence, %{name: name})
  end

  @doc """
  Atualiza uma sequência baseada em um changeset.
  Caso ocorra algum erro o mesmo é detalhado.
  """
  @impl ISequenceRepository
  def update(changeset) do
    Repo.update(changeset)
  end

  @doc """
  Deleta uma sequência.
  Caso ocorra algum erro o mesmo é detalhado.
  """
  @impl ISequenceRepository
  def delete(sequence) do
    case Repo.delete(sequence) do
      {:ok, _deleted} -> :ok

      {:error, changeset} -> ChangesetErrorsMessage.error_tuple_traverse_message(changeset)
    end
  end
end
