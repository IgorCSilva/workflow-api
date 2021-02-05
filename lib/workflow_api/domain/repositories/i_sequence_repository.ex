defmodule WorkflowApi.Domain.Repositories.ISequenceRepository do

  alias WorkflowApi.Domain.Schemas.Sequence

  @callback create(%Ecto.Changeset{}) :: {:ok, %Sequence{}} | {:error, map()}
  @callback list() :: [%Sequence{}]
  # @callback list_functions_query(Ecto.Queryable.t()) :: [%Function{}]
  @callback get(String.t() | integer()) :: %Sequence{} | nil
  @callback get_by_name(String.t()) :: %Sequence{} | nil
  @callback update(%Ecto.Changeset{}) :: {:ok, %Sequence{}} | {:error, map()}
  @callback delete(%Sequence{} | Ecto.Changeset.t()) :: :ok | {:error, map()}
end
