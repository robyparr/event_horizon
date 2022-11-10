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

    socket =
      socket
      |> assign(:page_title, page_title(socket.assigns.live_action))
      |> assign(:site, site)
      |> assign(:event_count, Sites.count_site_events(site))

    {:noreply, socket}
  end

  defp page_title(:show), do: "Show Site"
  defp page_title(:edit), do: "Edit Site"
end
