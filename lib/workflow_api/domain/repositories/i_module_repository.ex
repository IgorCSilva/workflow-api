defmodule WorkflowApi.Domain.Repositories.IModuleRepository do

  alias WorkflowApi.Domain.Schemas.{Module, Function}

  @callback create(%Ecto.Changeset{}, [%Function{}]) :: {:ok, %Module{}} | {:error, map()}
  @callback list() :: [%Module{}]
  # @callback list_plans_services() :: [map()]
  @callback get_module(String.t() | integer()) :: %Module{} | nil
  # @callback get_plan_by_name(String.t()) :: %Plan{} | nil | no_return()
  # @callback update_module(%Ecto.Changeset{}) :: {:ok, %Plan{}} | {:error, map()}
  @callback update_functions(%Module{}, String.t(), [String.t()]) :: {:ok, %Module{} | {:error, map()}}
  # @callback delete_plan(%Plan{} | Ecto.Changeset.t()) :: {:ok, %Plan{}} | {:error, map()}
end
