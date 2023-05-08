defmodule EventHorizonWeb.SiteLive.Index do
  use EventHorizonWeb, :live_view

  alias EventHorizon.Sites
  alias EventHorizon.Sites.Site

  @impl true
  def mount(_params, _session, socket) do
    sites = Sites.list_sites()

    {:ok,
     socket
     |> stream(:sites, sites)
     |> load_events_today_for_sites(sites)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Site")
    |> assign(:site, %Site{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Sites")
    |> assign(:site, nil)
  end

  @impl true
  def handle_info({EventHorizonWeb.SiteLive.FormComponent, {:saved, site}}, socket) do
    {:noreply, stream_insert(socket, :sites, site)}
  end

  defp load_events_today_for_sites(socket, sites) do
    events =
      Enum.reduce(sites, %{}, fn site, acc ->
        event_chart_data = Sites.recent_event_count_by_date(site, days: 1)
        Map.put(acc, site.id, event_chart_data[Date.utc_today()])
      end)

    assign(socket, :events_today, events)
  end
end
