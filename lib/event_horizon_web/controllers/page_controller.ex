defmodule EventHorizonWeb.PageController do
  use EventHorizonWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
