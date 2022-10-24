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
        name: "some name " <> Ecto.UUID.generate(),
        token: "some token"
      })
      |> EventHorizon.Sites.create_site()

    site
  end
end
