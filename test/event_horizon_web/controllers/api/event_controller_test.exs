defmodule EventHorizonWeb.Api.EventControllerTest do
  use EventHorizonWeb.ConnCase

  alias EventHorizon.Sites
  alias EventHorizon.Sites.Event

  @create_attrs %{
    action: "some action",
    count: 42,
    resource: "some resource",
    resource_type: "some resource_type"
  }

  @invalid_attrs %{action: nil}

  setup :create_and_auth_site

  setup %{conn: conn} do
    conn = put_req_header(conn, "accept", "application/json")
    {:ok, conn: conn}
  end

  describe "create event" do
    test "renders event when data is valid", %{conn: conn, site: site} do
      assert Sites.list_site_events(site) == []
      conn = post(conn, ~p"/api/events", event: @create_attrs)
      assert response(conn, 201) == ""

      assert [%Event{} = event] = Sites.list_site_events(site)
      assert event.action == @create_attrs.action
    end

    test "renders errors when data is invalid", %{conn: conn, site: site} do
      assert Sites.list_site_events(site) == []

      conn = post(conn, ~p"/api/events", event: @invalid_attrs)
      assert json_response(conn, 422) == %{"errors" => %{"action" => ["can't be blank"]}}
      assert Sites.list_site_events(site) == []
    end

    test "renders unauthorized if site token is invalid" do
      conn = build_conn()
      conn = post(conn, ~p"/api/events", event: @create_attrs)
      assert response(conn, 401) == ""
    end
  end
end
