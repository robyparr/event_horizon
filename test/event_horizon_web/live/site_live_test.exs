defmodule EventHorizonWeb.SiteLiveTest do
  use EventHorizonWeb.ConnCase

  import Phoenix.LiveViewTest
  import EventHorizon.SitesFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  setup :register_and_log_in_user

  defp create_site(_) do
    site = site_fixture()
    %{site: site}
  end

  describe "Index" do
    setup [:create_site]

    test "redirects if user is not logged in", %{site: site} do
      conn = build_conn()

      Enum.each(
        [
          ~p"/sites",
          ~p"/sites/new",
          ~p"/sites/#{site}/edit"
        ],
        fn route ->
          {:error, {:redirect, redirect_attrs}} = live(conn, route)
          assert redirect_attrs.to == "/user/log_in"
        end
      )
    end

    test "lists all sites", %{conn: conn, site: site} do
      {:ok, _index_live, html} = live(conn, ~p"/sites")

      assert html =~ "Listing Sites"
      assert html =~ site.name
    end

    test "saves new site", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/sites")

      assert index_live |> element("a", "New Site") |> render_click() =~
               "New Site"

      assert_patch(index_live, ~p"/sites/new")

      assert index_live
             |> form("#site-form", site: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#site-form", site: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/sites")

      html = render(index_live)
      assert html =~ "Site created successfully"
      assert html =~ "some name"
    end
  end

  describe "Show" do
    setup [:create_site]

    test "redirects if user is not logged in", %{site: site} do
      conn = build_conn()

      Enum.each(
        [
          ~p"/sites/#{site}",
          ~p"/sites/#{site}/show/edit"
        ],
        fn route ->
          {:error, {:redirect, redirect_attrs}} = live(conn, route)
          assert redirect_attrs.to == "/user/log_in"
        end
      )
    end

    test "displays site", %{conn: conn, site: site} do
      {:ok, _show_live, html} = live(conn, ~p"/sites/#{site}")

      assert html =~ "Show Site"
      assert html =~ site.name
    end

    test "updates site within modal", %{conn: conn, site: site} do
      {:ok, show_live, _html} = live(conn, ~p"/sites/#{site}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Site"

      assert_patch(show_live, ~p"/sites/#{site}/show/edit")

      assert show_live
             |> form("#site-form", site: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#site-form", site: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/sites/#{site}")

      html = render(show_live)
      assert html =~ "Site updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes site", %{conn: conn, site: site} do
      {:ok, show_live, _html} = live(conn, ~p"/sites/#{site}")

      {:ok, index_live, html} =
        show_live
        |> element("a", "Delete")
        |> render_click()
        |> follow_redirect(conn, ~p"/sites")

      assert html =~ "#{site.name} deleted successfully."
      refute has_element?(index_live, "#site-#{site.id}")
    end
  end
end
