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

    test "get_site_by_token/1 returns the site with the given token" do
      site = site_fixture()
      other_site = site_fixture()

      assert Sites.get_site_by_token(site.token) == site
      assert Sites.get_site_by_token(other_site.token) == other_site
    end

    test "get_site_by_token/1 returns nil when token doesn't belong to a site" do
      assert Sites.get_site_by_token("fake_token") == nil
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

  describe "site_events" do
    alias EventHorizon.Sites.Event

    import EventHorizon.SitesFixtures

    @invalid_attrs %{action: nil}

    setup do
      %{site: site_fixture()}
    end

    test "list_site_events/0 returns all site_events", %{site: site} do
      event = event_fixture(site)
      _other_site_event = event_fixture()

      assert Sites.list_site_events(site) == [event]
    end

    test "create_event/1 with valid data creates a event", %{site: site} do
      valid_attrs = %{
        action: "some action",
        count: 42,
        resource: "some resource",
        resource_type: "some resource_type"
      }

      assert {:ok, %Event{} = event} = Sites.create_event(site, valid_attrs)
      assert event.site_id == site.id
      assert event.action == "some action"
      assert event.count == 42
      assert event.resource == "some resource"
      assert event.resource_type == "some resource_type"
    end

    test "create_event/1 with invalid data returns error changeset", %{site: site} do
      assert {:error, %Ecto.Changeset{}} = Sites.create_event(site, @invalid_attrs)
    end
  end
end
