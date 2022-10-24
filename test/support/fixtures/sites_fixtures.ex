defmodule EventHorizon.SitesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `EventHorizon.Sites` context.
  """

  @doc """
  Generate a site.
  """
  def site_fixture(attrs \\ %{}) do
    {:ok, site} =
      attrs
      |> Enum.into(%{
        name: "some name " <> Ecto.UUID.generate()
      })
      |> EventHorizon.Sites.create_site()

    site
  end

  @doc """
  Generate am event.
  """
  def event_fixture(site \\ site_fixture(), attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        action: "some action",
        resource: "some resource",
        resource_type: "some resource_type",
        count: 1
      })

    {:ok, event} = EventHorizon.Sites.create_event(site, attrs)
    event
  end
end
