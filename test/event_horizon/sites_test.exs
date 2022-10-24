defmodule EventHorizon.SitesTest do
  use EventHorizon.DataCase

  alias EventHorizon.Sites

  describe "sites" do
    alias EventHorizon.Sites.Site

    import EventHorizon.SitesFixtures

    @invalid_attrs %{name: nil, token: nil}

    test "list_sites/0 returns all sites" do
      site = site_fixture()
      assert Sites.list_sites() == [site]
    end

    test "get_site!/1 returns the site with given id" do
      site = site_fixture()
      assert Sites.get_site!(site.id) == site
    end

    test "create_site/1 with valid data creates a site" do
      valid_attrs = %{name: "some name", token: "some token"}

      assert {:ok, %Site{} = site} = Sites.create_site(valid_attrs)
      assert site.name == "some name"
      assert site.token != valid_attrs[:token]
      assert String.length(site.token) == 43
    end

    test "create_site/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sites.create_site(@invalid_attrs)
    end

    test "update_site/2 with valid data updates the site" do
      site = site_fixture()
      original_token = site.token
      update_attrs = %{name: "some updated name", token: "some updated token"}

      assert {:ok, %Site{} = site} = Sites.update_site(site, update_attrs)
      assert site.name == "some updated name"
      assert site.token == original_token
    end

    test "update_site/2 with invalid data returns error changeset" do
      site = site_fixture()
      assert {:error, %Ecto.Changeset{}} = Sites.update_site(site, @invalid_attrs)
      assert site == Sites.get_site!(site.id)
    end

    test "delete_site/1 deletes the site" do
      site = site_fixture()
      assert {:ok, %Site{}} = Sites.delete_site(site)
      assert_raise Ecto.NoResultsError, fn -> Sites.get_site!(site.id) end
    end

    test "change_site/1 returns a site changeset" do
      site = site_fixture()
      assert %Ecto.Changeset{} = Sites.change_site(site)
    end
  end
end
