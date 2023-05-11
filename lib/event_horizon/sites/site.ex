defmodule EventHorizon.Sites.Site do
  use Ecto.Schema
  import Ecto.Changeset

  alias EventHorizon.Sites

  @rand_size 32

  schema "sites" do
    field :name, :string
    field :token, :string

    has_many :events, Sites.Event
    has_many :metrics, Sites.Metric

    timestamps()
  end

  @doc false
  def changeset(site, attrs) do
    site
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> maybe_generate_token()
  end

  defp maybe_generate_token(%Ecto.Changeset{} = changeset) do
    if get_field(changeset, :token) do
      changeset
    else
      token =
        :crypto.strong_rand_bytes(@rand_size)
        |> Base.url_encode64(padding: false)

      put_change(changeset, :token, token)
    end
  end
end
