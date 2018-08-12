defmodule DbixirWeb.PageController do
  use DbixirWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
