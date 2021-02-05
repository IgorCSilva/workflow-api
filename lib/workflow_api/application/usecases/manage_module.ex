defmodule WorkflowApi.Application.Usecases.ManageModule do

  import Ecto.Changeset
  import Ecto.Query

  alias WorkflowApi.Repo
  alias WorkflowApi.Domain.Schemas.{Module, Function}
  alias WorkflowApi.Application.Utils.ChangesetErrorsMessage

  def create(params, module_repository, function_repository) do
    with {:ok, functions_id} <- Map.fetch(params, "module_functions"),
      true <- Enum.all?(functions_id, fn (f) -> Ecto.UUID.cast(f) != :error end) do

        # Validating data.
        case changeset = Module.changeset(params) do
          %Ecto.Changeset{:valid? => true} ->

            # Pegando a lista de ids das funções fornecidos por este módulo.
            functions_list = Enum.map(functions_id, fn f_id ->
              {:ok, string_uuid} = Ecto.UUID.cast(f_id)
              string_uuid
            end)

            # Motando query para buscar funções do módulo.
            functions_schemas_list_query =
              from s in Function,
                where: s.id in ^functions_list

            # Buscando funções no banco de dados.
            functions_schemas_list =
              function_repository.list_functions_query(functions_schemas_list_query)

            # Lista de ids das funções buscadas.
            functions_ids =
              Enum.map(functions_schemas_list, fn (function) ->
                function.id
              end)

            # Verificando quais funções estão faltando.
            missing_functions = functions_list -- functions_ids

            if (Enum.empty?(missing_functions)) do
              module_repository.create(changeset, functions_schemas_list)
              # IO.inspect(functions_schemas_list)
            else
              {:error, %{missing_functions: missing_functions}}
            end

          changeset -> {:error, ChangesetErrorsMessage.traverse_message(changeset)}

        end
    else
      :error -> {:error, "You need to define the functions id."}
      false -> {:error, "There is some invalid function id."}
    end
  end

  def list(repository) do
    repository.list()
  end

  @doc """
  Update module's functions, adding, removing, replacing them or return associated error with the
  wrong data.
  """
  def update_functions(params, repository) do
    with {:ok, module_id} <- Map.fetch(params, "id"),
      {:uuid, {:ok, id}} <- {:uuid, Ecto.UUID.cast(module_id)},
      {:ok, functions} <- Map.fetch(params, "functions"),
      {:uuid, true} <- {:uuid, Enum.all?(functions, fn (f) -> Ecto.UUID.cast(f) != :error end)},
      {:ok, action} <- Map.fetch(params, "action"),
      true <- Enum.member?(["add", "remove", "replace"], action) do

        case repository.get_module(id) do
          nil ->
            {:error, "Este módulo não existe."}

          module ->

            repository.update_functions(module, action, functions)

            # {:ok, {qty, update_list}} = repository.update_functions(module_with_binary_uuid, action, functions_binary_uuid)


            # {:ok, {3, "string_uuids"}}
        end

    else
      :error ->
        {:error, "Um ou mais destes parâmetros não foram fornecidos: id, action e functions."}
      false -> {:error, "Invalid action. The existent actions are: add, remove and replace."}
      {:uuid, :error} -> {:error, "Invalid id."}
      {:uuid, false} -> {:error, "Some invalid function id."}
        _ -> {:error, "Erro ao tratar os dados de atualização de funções de um módulo."}
    end
  end

end
