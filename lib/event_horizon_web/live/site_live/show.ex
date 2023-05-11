defmodule EventHorizonWeb.SiteLive.Show do
  use EventHorizonWeb, :live_view

  alias EventHorizon.Sites

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    site = Sites.get_site!(id)
    event_chart_data = Sites.recent_event_count_by_date(site)
    metric_grouping =
      Sites.sum_metrics(site)
      |> Enum.group_by(&(&1.name))

    socket =
      socket
      |> assign(:page_title, page_title(socket.assigns.live_action))
      |> assign(:site, site)
      |> assign(:event_count, Sites.count_site_events(site))
      |> assign(:todays_event_count, event_chart_data[Date.utc_today()])
      |> assign(:metric_grouping, metric_grouping)
      |> push_chart_data("event-chart", {"Events", event_chart_data})

    {:noreply, socket}
  end

  @impl true
  def handle_event("delete", _params, socket) do
    site = socket.assigns.site
    {:ok, _} = Sites.delete_site(site)

    {:noreply,
     socket
     |> put_flash(:info, "#{site.name} deleted successfully.")
     |> push_navigate(to: ~p"/sites")}
  end

  defp page_title(:show), do: "Show Site"
  defp page_title(:edit), do: "Edit Site"

  defp push_chart_data(socket, chart_id, dataset) do
    {label, data} = dataset

    push_event(socket, "render-chart", %{
      id: chart_id,
      labels: Map.keys(data),
      datasets: [%{label: label, data: data}],
      values: Map.values(data)
    })
  end

  defp metric_icon(name) do
    case name do
      "browser" -> "hero-globe-alt"
      "device_type" -> "hero-computer-desktop"
      "operating_system" -> "hero-cpu-chip"
      _ -> "hero-question-mark-circle"
    end
  end
end
