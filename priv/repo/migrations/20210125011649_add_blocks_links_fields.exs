defmodule WorkflowApi.Repo.Migrations.AddBlocksLinksFields do
  use Ecto.Migration

  def change do
    alter table(:sequences) do
      add :blocks, :map, null: false
      add :links, :map, null: false
    end
  end
end
