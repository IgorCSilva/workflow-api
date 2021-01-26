defmodule WorkflowApi.Domain.Repositories.IFunctionRepository do

  alias WorkflowApi.Domain.Schemas.Function

  @callback create(%Ecto.Changeset{}) :: {:ok, %Function{}} | {:error, map()}
  @callback list() :: [%Function{}]
  @callback list_functions_query(Ecto.Queryable.t()) :: [%Function{}]
  @callback get_by_id_list([String.t()]) :: [%Function{}]
  # @callback update_service(%Ecto.Changeset{}) :: {:ok, %Service{}} | {:error, map()}
  # @callback delete_service(%Service{} | Ecto.Changeset.t()) :: {:ok, %Service{}} | {:error, map()}
end
