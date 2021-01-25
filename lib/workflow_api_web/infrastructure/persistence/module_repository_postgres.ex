defmodule WorkflowApiWeb.Infrastructure.Persistence.ModuleRepositoryPostgres do

  import Ecto.Query
  import Ecto.Changeset

  alias WorkflowApi.Repo
  alias WorkflowApi.Domain.Schemas.{Module, Function}
  alias WorkflowApi.Domain.Repositories.{IModuleRepository}
  alias WorkflowApi.Application.Utils.ChangesetErrorsMessage

  @behaviour IModuleRepository

  @doc """
  Criando plano e o retornando com o campo de serviços carregado.
  """
  @impl IModuleRepository
  def create(changeset, functions) do
    Repo.transaction(fn ->

      # Insere um registro de módulo, carrega o campo de funções
      # e associa às funções fornecidas.
      case Repo.insert(changeset) do
        {:ok, module} ->
          module
          |> Repo.preload([:functions])
          |> change()
          |> put_assoc(:functions, functions)
          |> Repo.update!()

        {:error, changeset} ->
          traverse = ChangesetErrorsMessage.traverse_message(changeset)
          Repo.rollback(traverse)
      end

    end)
  end

  @doc """
  Retorna todos os módulos.
  """
  @impl IModuleRepository
  def list do
    Repo.all(from Module)
    |> Enum.map(fn module ->
      Repo.preload(module, [:functions])
    end)
  end

  @doc """
  Buscando módulo pelo seu id e retornando com campo de funções
  carregado.
  """
  @impl IModuleRepository
  def get_module(module_id) do
    Repo.get(Module, module_id)
    |> Repo.preload(:functions)
  end

  @impl IModuleRepository
  def update_functions(module, "add", functions) do

    current_functions = module.functions

    current_functions_id = Enum.map(current_functions, fn cf ->
      cf.id
    end)

    # Retirando ids de funções que já pertencem ao módulo.
    functions_to_add = functions -- current_functions_id

    # Buscando novas funções no banco de dados e removendo da lista os nils.
    new_functions =
      functions_to_add
      |> Enum.map(fn function_id ->
        Repo.get(Function, function_id)
      end)
      |> Enum.filter(fn function ->
        not is_nil(function)
      end)

    IO.inspect(new_functions ++ current_functions)

    updated_module = change(module, %{functions: current_functions ++ new_functions})
    # IO.inspect(updated_module)

    case Repo.update(updated_module) do
      {:ok, module} ->
        complete_module =
          module
          |> Repo.preload([:functions])

        {:ok, complete_module}

      {:error, error} -> {:error, error}
    end
  end

  @impl IModuleRepository
  def update_functions(module, "remove", functions) do

    functions_to_continue = Enum.filter(module.functions, fn function ->
      function.id not in functions
    end)

    updated_module = change(module, %{functions: functions_to_continue})
    # IO.inspect(updated_module)

    case Repo.update(updated_module) do
      {:ok, module} ->
        complete_module =
          module
          |> Repo.preload([:functions])

        {:ok, complete_module}

      {:error, error} -> {:error, error}
    end
  end

  # @doc """
  # Removendo funções de um módulo.
  # """
  # @impl IModuleRepository
  # def update_services(module, "remove", services) do

  #   # Query para buscar registros relacionados ao módulo e as funções que devem ser deletados.
  #   assoc_to_delete_query = from ps in "plans_services",
  #     where: ps.plan_id == ^plan.id and ps.service_id in ^services,
  #     select: [:plan_id, :service_id]

  #   # Deletando associações.
  #   # Retornando {qty_changed, list_deleted}.
  #   {:ok, Repo.delete_all(assoc_to_delete_query)}
  # end

  # @doc """
  # Adicionando serviços a um plano.
  # """
  # @impl IModuleRepository
  # def update_services(plan, "add", services) do
  #   # Query para pega id dos serviços que pertencem ao plano e já estão associados a ele.
  #   list_service_id_plan_query = from ps in "plans_services",
  #     where: ps.plan_id == ^plan.id and (ps.service_id in ^services),
  #     select: ps.service_id

  #   # Lista de ids de serviços que o plano está associado.
  #   list_service_id_plan = Repo.all(list_service_id_plan_query)

  #   # Query para buscar os ids dos serviços existentes.
  #   services_id_query = from s in "services", select: s.id
  #   services_id = Repo.all(services_id_query)

  #   # Deixando apenas os ids que ainda não estão associados ao plano.
  #   list_ids_to_insert =
  #     services
  #     |> Enum.reject(fn (id) ->
  #       id in list_service_id_plan
  #     end)
  #     |> Enum.filter(fn (id) ->
  #       id in services_id
  #     end)

  #   # Montando lista de relações a serem adicionadas.
  #   changes =
  #     Enum.reduce(list_ids_to_insert, [], fn (id, acc) ->
  #       [%{plan_id: plan.id, service_id: id} | acc]
  #     end)

  #   # Inserindo relações.
  #   # Retornando {qty_changed, list_deleted}.
  #   {:ok, Repo.insert_all("plans_services", changes, returning: [:plan_id, :service_id])}
  # end

  # @doc """
  # Sobrescrevendo todos os serviços de um plano.
  # """
  # @impl IModuleRepository
  # def update_services(plan, "replace", services) do
  #   # Query para relações referentes ao plano.
  #   list_plan_query = from ps in "plans_services",
  #     where: ps.plan_id == ^plan.id,
  #     select: [:plan_id, :service_id]

  #   # Query para buscar os ids dos serviços existentes.
  #   services_id_query = from s in "services", select: s.id
  #   services_id = Repo.all(services_id_query)

  #   # Deixando apenas os ids válidos.
  #   list_ids_to_insert =
  #     services
  #     |> Enum.filter(fn (id) ->
  #       id in services_id
  #     end)

  #   # Montando lista de relações a serem adicionadas.
  #   changes =
  #     Enum.reduce(list_ids_to_insert, [], fn (id, acc) ->
  #       [%{plan_id: plan.id, service_id: id} | acc]
  #     end)

  #   # Deletando relações e adicionando novas.
  #   Repo.transaction(fn ->
  #     Repo.delete_all(list_plan_query)
  #     # {value, result} = List.pop_at(changes, 0)
  #     {qty, return} = Repo.insert_all("plans_services", changes, returning: [:plan_id, :service_id])

  #     cond do
  #       qty == Enum.count(changes) ->
  #         {qty, return}

  #       # Caso a quantidade inserida tenha sido diferente.
  #       true ->
  #         Repo.rollback("Quantidade incorreta inserida no banco de dados.")
  #     end
  #   end)
  # end

end
