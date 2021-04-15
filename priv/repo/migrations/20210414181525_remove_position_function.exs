defmodule WorkflowApi.Repo.Migrations.RemovePositionFunction do
  use Ecto.Migration

  def change do
    alter table(:functions) do
      remove :block_position_x, :integer
      remove :block_position_y, :integer
    end
  end
end
