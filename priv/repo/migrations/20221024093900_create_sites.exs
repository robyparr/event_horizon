defmodule EventHorizon.Repo.Migrations.CreateSites do
  use Ecto.Migration

  def change do
    create table(:sites) do
      add :name, :string, null: false
      add :token, :string, null: false

      timestamps()
    end

    create unique_index(:sites, [:name])
    create unique_index(:sites, [:token])
  end
end
