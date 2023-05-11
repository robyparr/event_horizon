defmodule EventHorizonWeb.Api.EventController do
  use EventHorizonWeb, :controller

  alias EventHorizon.Sites
  alias EventHorizon.Sites.Event

  action_fallback EventHorizonWeb.Api.FallbackController

  def create(conn, %{"event" => event_params}) do
    site = conn.assigns.current_site

    with {:ok, %Event{} = _event} <- Sites.create_event(site, event_params) do
      user_agent =
        Plug.Conn.get_req_header(conn, "user-agent")
        |> List.first()
        |> UAInspector.parse()

      Sites.increment_metric(site, "device_type", user_agent.device.type)
      Sites.increment_metric(site, "operating_system", user_agent.os.name)
      Sites.increment_metric(site, "browser", user_agent.client.name)

      send_resp(conn, :created, "")
    end
  end
end
