defmodule WorkflowApi.Repo.Migrations.AlterFunctionTabel do
  use Ecto.Migration

  def change do
    alter table(:functions) do
      add :module_id, references(:modules, type: :uuid, on_delete: :delete_all)
    end
  end
end
