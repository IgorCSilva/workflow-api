defmodule WorkflowApiWeb.Infrastructure.Persistence.FunctionRepositoryPostgres do

  import Ecto.Query

  alias WorkflowApi.Repo
  alias WorkflowApi.Domain.Schemas.Function
  alias WorkflowApi.Domain.Repositories.IFunctionRepository
  alias WorkflowApi.Application.Utils.ChangesetErrorsMessage

  @behaviour IFunctionRepository

  @doc """
  Cria uma função a partir de um changeset.
  Caso ocorra algum erro o mesmo é detalhado.
  """
  @impl IFunctionRepository
  def create(function_changeset) do
    # Tenta inserir a função no banco de dados.
    case Repo.insert(function_changeset) do
      {:ok, function} -> {:ok, function}

      {:error, changeset} -> ChangesetErrorsMessage.error_tuple_traverse_message(changeset)
    end
  end

  @doc """
  Retorna todas as funções.
  """
  @impl IFunctionRepository
  def list do
    Repo.all(from Function)
  end

  @doc """
  Retorna todos os serviços baseado numa consulta.
  """
  @impl IFunctionRepository
  def list_functions_query(query) do
    Repo.all(query)
  end

  @impl IFunctionRepository
  def get_by_id_list(list) do
    query = from f in Function, where: f.id in ^list

    Repo.all(query)
    |> Enum.map(fn function ->
      Repo.preload(function, [:module])
    end)
  end
  @doc """
  Retorna uma função.
  """
  @impl IFunctionRepository
  def get(id) do
    Repo.get(Function, id)
  end

  @doc """
  Atualiza um serviço baseado em um changeset.
  Caso ocorra algum erro o mesmo é detalhado.
  """
  @impl IFunctionRepository
  def update(changeset) do
    Repo.update(changeset)
  end

  @doc """
  Deleta um serviço.
  Caso ocorra algum erro o mesmo é detalhado.
  """
  # @impl IServiceRepository
  # def delete_service(service) do
  #   case Repo.delete(service) do
  #     {:ok, deleted_service} -> {:ok, deleted_service}

  #     {:error, changeset} -> ChangesetErrorsMessage.error_tuple_traverse_message(changeset)
  #   end
  # end

end
