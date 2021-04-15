defmodule WorkflowApi.Repo.Migrations.AddArrayFunction do
  use Ecto.Migration

  def change do
    alter table(:sequences) do
      remove :blocks
      remove :links
      add :functions_sequence, {:array, :string}
    end
  end
end
