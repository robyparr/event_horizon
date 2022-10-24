defmodule EventHorizonWeb.Api.SiteAuth do
  import Plug.Conn

  alias EventHorizon.Sites

  def ensure_site_authenticated(conn, _opts) do
    conn = load_site(conn)

    if conn.assigns[:current_site] do
      conn
    else
      conn
      |> send_resp(:unauthorized, "")
      |> halt()
    end
  end

  defp load_site(conn) do
    token = resolve_auth_token(conn)
    site = token && Sites.get_site_by_token(token)
    assign(conn, :current_site, site)
  end

  defp resolve_auth_token(conn) do
    case get_req_header(conn, "authorization") do
      [header_value] ->
        header_value
        |> String.split(" ")
        |> List.last()

      _ ->
        nil
    end
  end
end
