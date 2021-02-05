defmodule WorkflowApi.Repo.Migrations.CreateSequenceTable do
  use Ecto.Migration

  def change do
    create table(:sequences, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
      add :description, :text

      timestamps()
    end
  end
end
