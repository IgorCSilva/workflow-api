defmodule WorkflowApi.Domain.Repositories.ISequenceRepository do

  alias WorkflowApi.Domain.Schemas.Sequence

  @callback set(%Ecto.Changeset{}) :: {:ok, %Sequence{}} | {:error, map()}
  @callback list() :: [%Sequence{}]
  # @callback list_functions_query(Ecto.Queryable.t()) :: [%Function{}]
  # @callback get_service(String.t() | integer()) :: %Service{} | nil
  # @callback update_service(%Ecto.Changeset{}) :: {:ok, %Service{}} | {:error, map()}
  # @callback delete_service(%Service{} | Ecto.Changeset.t()) :: {:ok, %Service{}} | {:error, map()}
end
