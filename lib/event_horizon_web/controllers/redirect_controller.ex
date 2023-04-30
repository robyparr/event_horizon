defmodule EventHorizonWeb.RedirectController do
  use EventHorizonWeb, :controller

  def index(conn, _params) do
    redirect(conn, to: ~p"/sites")
  end
end
