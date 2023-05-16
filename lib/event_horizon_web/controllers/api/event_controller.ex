defmodule EventHorizonWeb.Api.EventController do
  use EventHorizonWeb, :controller

  alias EventHorizon.Sites
  alias EventHorizon.Sites.Event

  action_fallback EventHorizonWeb.Api.FallbackController

  def create(conn, %{"event" => event_params}) do
    site = conn.assigns.current_site

    with {:ok, %Event{} = _event} <- Sites.create_event(site, event_params) do
      increment_metrics(conn, site)
      send_resp(conn, :created, "")
    end
  end

  defp increment_metrics(conn, site) do
    user_agent =
      Plug.Conn.get_req_header(conn, "user-agent")
      |> List.first()
      |> UAInspector.parse()

    device_type = get_in(user_agent, Enum.map(~w[device type]a, &Access.key/1)) || "Unknown"
    Sites.increment_metric(site, "device_type", device_type)

    operating_system = get_in(user_agent, Enum.map(~w[os name]a, &Access.key/1)) || "Unknown"
    Sites.increment_metric(site, "operating_system", operating_system)

    browser = get_in(user_agent, Enum.map(~w[client name]a, &Access.key/1)) || "Unknown"
    Sites.increment_metric(site, "browser", browser)
  end
end
