defmodule EventHorizonWeb.EventControllerTest do
  use EventHorizonWeb.ConnCase

  import EventHorizon.SitesFixtures

  alias EventHorizon.Sites
  alias EventHorizon.Sites.Event

  @create_attrs %{
    action: "some action",
    count: 42,
    resource: "some resource",
    resource_type: "some resource_type"
  }

  @invalid_attrs %{action: nil}

  setup do
    %{site: site_fixture()}
  end

  setup %{conn: conn, site: site} do
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer #{site.token}")

    {:ok, conn: conn}
  end

  describe "create event" do
    test "renders event when data is valid", %{conn: conn, site: site} do
      assert Sites.list_site_events(site) == []
      conn = post(conn, Routes.event_path(conn, :create), event: @create_attrs)
      assert response(conn, 201)

      assert [%Event{} = event] = Sites.list_site_events(site)
      assert event.action == @create_attrs.action
    end

    test "renders errors when data is invalid", %{conn: conn, site: site} do
      assert Sites.list_site_events(site) == []

      conn = post(conn, Routes.event_path(conn, :create), event: @invalid_attrs)
      assert json_response(conn, 422) == %{"errors" => %{"action" => ["can't be blank"]}}
      assert Sites.list_site_events(site) == []
    end
  end
end
