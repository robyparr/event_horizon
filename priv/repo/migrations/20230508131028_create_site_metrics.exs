defmodule EventHorizon.Repo.Migrations.CreateSiteMetricLogs do
  use Ecto.Migration

  def change do
    create table(:site_metrics) do
      add :site_id, references(:sites, on_delete: :delete_all), null: false
      add :date, :date, null: false
      add :name, :string, null: false
      add :value, :string, null: false
      add :count, :bigint, null: false
    end

    create index(:site_metrics, [:site_id, :date, :name, :value], unique: true)
  end
end
