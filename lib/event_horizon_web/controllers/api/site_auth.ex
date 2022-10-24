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
    token =
      get_req_header(conn, "authorization")
      |> List.first()
      |> String.split(" ")
      |> List.last()

    site = token && Sites.get_site_by_token(token)
    assign(conn, :current_site, site)
  end
end
