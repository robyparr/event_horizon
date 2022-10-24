defmodule EventHorizonWeb.RedirectControllerTest do
  use EventHorizonWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert redirected_to(conn) == "/user/log_in"
  end

  test "GET / when authenticated", %{conn: conn} do
    conn = register_and_log_in_user(%{conn: conn}).conn

    conn = get(conn, "/")
    assert redirected_to(conn) == "/sites"
  end
end
