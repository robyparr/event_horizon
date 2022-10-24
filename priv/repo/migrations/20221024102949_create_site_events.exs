defmodule EventHorizon.Repo.Migrations.CreateSiteEvents do
  use Ecto.Migration

  def change do
    create table(:site_events) do
      add :action, :string, null: false
      add :resource, :string, null: true
      add :resource_type, :string, null: true
      add :count, :integer, null: false, default: 1
      add :site_id, references(:sites, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:site_events, [:site_id])
  end
end
