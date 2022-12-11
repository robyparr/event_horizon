defmodule EventHorizon.Sites do
  @moduledoc """
  The Sites context.
  """

  import Ecto.Query, warn: false
  alias EventHorizon.Repo

  alias EventHorizon.Sites.Site
  alias EventHorizon.Sites.Event

  @doc """
  Returns the list of sites.

  ## Examples

      iex> list_sites()
      [%Site{}, ...]

  """
  def list_sites do
    Repo.all(Site)
  end

  @doc """
  Gets a single site.

  Raises `Ecto.NoResultsError` if the Site does not exist.

  ## Examples

      iex> get_site!(123)
      %Site{}

      iex> get_site!(456)
      ** (Ecto.NoResultsError)

  """
  def get_site!(id), do: Repo.get!(Site, id)

  def get_site_by_token(token), do: Repo.get_by(Site, token: token)

  @doc """
  Creates a site.

  ## Examples

      iex> create_site(%{field: value})
      {:ok, %Site{}}

      iex> create_site(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_site(attrs \\ %{}) do
    %Site{}
    |> Site.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a site.

  ## Examples

      iex> update_site(site, %{field: new_value})
      {:ok, %Site{}}

      iex> update_site(site, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_site(%Site{} = site, attrs) do
    site
    |> Site.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a site.

  ## Examples

      iex> delete_site(site)
      {:ok, %Site{}}

      iex> delete_site(site)
      {:error, %Ecto.Changeset{}}

  """
  def delete_site(%Site{} = site) do
    Repo.delete(site)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking site changes.

  ## Examples

      iex> change_site(site)
      %Ecto.Changeset{data: %Site{}}

  """
  def change_site(%Site{} = site, attrs \\ %{}) do
    Site.changeset(site, attrs)
  end

  def list_site_events(%Site{} = site) do
    Ecto.assoc(site, :events)
    |> Repo.all()
  end

  def count_site_events(%Site{} = site) do
    Ecto.assoc(site, :events)
    |> Repo.aggregate(:count)
  end

  def create_event(%Site{} = site, attrs \\ %{}) do
    Ecto.build_assoc(site, :events)
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  def recent_event_count_by_date(site, opts \\ []) do
    recent_days = Keyword.get(opts, :days, 5)
    end_on = Date.utc_today()
    start_on = Date.add(end_on, -recent_days)

    query =
      from e in Event,
        where:
          e.site_id == ^site.id and
            fragment("?::DATE BETWEEN ? AND ?", e.inserted_at, ^start_on, ^end_on),
        group_by: fragment("DATE_TRUNC('day', ?)", e.inserted_at),
        order_by: {:asc, fragment("DATE_TRUNC('day', ?)", e.inserted_at)},
        select: {fragment("DATE_TRUNC('day', ?)::DATE", e.inserted_at), count(e.id)}

    Repo.all(query)
    |> Map.new()
    |> fill_missing_event_counts(start_on, end_on)
  end

  defp fill_missing_event_counts(data, start_on, end_on) do
    map_func = fn date ->
      event_count = Map.get(data, date, 0)
      {date, event_count}
    end

    Date.range(start_on, end_on)
    |> Enum.map(map_func)
    |> Map.new()
  end
end
