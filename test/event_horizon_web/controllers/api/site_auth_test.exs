defmodule EventHorizonWeb.Api.SiteAuthTest do
  use EventHorizonWeb.ConnCase, async: true

  alias EventHorizonWeb.Api.SiteAuth
  alias EventHorizon.Sites

  setup :create_and_auth_site

  describe "ensure_site_authenticated/2" do
    test "conn.assigns.current_site is nil", %{conn: conn} do
      assert conn.assigns[:current_site] == nil
    end

    test "authenticates site from authorization header", %{conn: conn, site: site} do
      conn = SiteAuth.ensure_site_authenticated(conn, [])
      assert conn.assigns.current_site.id == site.id
    end

    test "send unauthorized if token is invalid", %{conn: conn, site: site} do
      Sites.delete_site(site)

      conn = SiteAuth.ensure_site_authenticated(conn, [])
      assert conn.halted
      assert response(conn, 401) == ""
      assert conn.assigns[:current_site] == nil
    end

    test "sends unauthorized if token is missing" do
      conn =
        build_conn()
        |> SiteAuth.ensure_site_authenticated([])

      assert conn.halted
      assert response(conn, 401) == ""
      assert conn.assigns[:current_site] == nil
    end
  end
end
