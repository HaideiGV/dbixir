defmodule DbixirWeb.ConnectionView do
  use DbixirWeb, :view
  alias DbixirWeb.ConnectionView

  def render("index.json", %{connections: connections}) do
    %{data: render_many(connections, ConnectionView, "connection.json")}
  end

  def render("show.json", %{connection: connection}) do
    %{data: render_one(connection, ConnectionView, "connection.json")}
  end

  def render("connection.json", %{connection: connection}) do
    %{id: connection.id,
      name: connection.name,
      port: connection.port,
      hostname: connection.hostname,
      username: connection.username,
      password: connection.password,
      db_name: connection.db_name}
  end
end
