defmodule WorkflowApi.Domain.Repositories.IFunctionRepository do

  alias WorkflowApi.Domain.Schemas.Function

  @callback create(%Ecto.Changeset{}) :: {:ok, %Function{}} | {:error, map()}
  @callback list() :: [%Function{}]
  @callback list_functions_query(Ecto.Queryable.t()) :: [%Function{}]
  @callback get_by_id_list([String.t()]) :: [%Function{}]
  @callback get(String.t() | integer()) :: %Function{} | nil
  @callback update(%Ecto.Changeset{}) :: {:ok, %Function{}} | {:error, map()}
  @callback delete(%Function{} | Ecto.Changeset.t()) :: :ok | {:error, map()}

end
