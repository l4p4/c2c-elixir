defmodule C2cWeb.PageController do
  use C2cWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
