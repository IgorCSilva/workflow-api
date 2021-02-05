defmodule WorkflowApi.Repo.Migrations.AddFunctionTable do
  use Ecto.Migration

  def change do
    create table(:functions, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :function, :string, null: false
      add :label, :string
      add :description, :text
      add :arity, :integer, null: false
      add :argumentsType, {:array, :string}
      add :responsesType, {:array, :string}
      add :block_position_x, :integer
      add :block_position_y, :integer
    end
  end
end
