defmodule WorkflowApi.Repo.Migrations.CreateModuleTable do
  use Ecto.Migration

  def change do
    create table(:modules, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :module, :string, null: false
      add :label, :string, null: false
      add :description, :text

      timestamps()
    end
  end
end
