defmodule EventHorizonWeb.RedirectController do
  use EventHorizonWeb, :controller

  def index(conn, _params) do
    redirect(conn, to: Routes.site_index_path(conn, :index))
  end
end
