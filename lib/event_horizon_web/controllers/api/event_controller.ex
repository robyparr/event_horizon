defmodule EventHorizonWeb.Api.EventController do
  use EventHorizonWeb, :controller

  alias EventHorizon.Sites
  alias EventHorizon.Sites.Event

  action_fallback EventHorizonWeb.Api.FallbackController

  def create(conn, %{"event" => event_params}) do
    site = conn.assigns.current_site

    with {:ok, %Event{} = _event} <- Sites.create_event(site, event_params) do
      send_resp(conn, :created, "")
    end
  end
end
