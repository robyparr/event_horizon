defmodule EventHorizon.Sites.Metric do
  use Ecto.Schema
  import Ecto.Changeset

  alias EventHorizon.Sites

  schema "site_metrics" do
    field :date, :date
    field :name, :string
    field :value, :string
    field :count, :integer

    belongs_to :site, Sites.Site
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:date, :name, :value, :count])
  end
end
