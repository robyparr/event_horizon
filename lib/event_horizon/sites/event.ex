defmodule EventHorizon.Sites.Event do
  use Ecto.Schema
  import Ecto.Changeset

  alias EventHorizon.Sites

  schema "site_events" do
    field :action, :string
    field :count, :integer
    field :resource, :string
    field :resource_type, :string

    belongs_to :site, Sites.Site

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:action, :resource, :resource_type, :count])
    |> validate_required([:action])
  end
end
