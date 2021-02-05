defmodule WorkflowApi.Repo.Migrations.AddTimestampsFunctions do
  use Ecto.Migration

  def change do
    alter table(:functions) do
      timestamps()
    end
  end
end
