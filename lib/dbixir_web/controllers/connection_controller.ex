defmodule DbixirWeb.ConnectionController do
  use DbixirWeb, :controller

  alias Dbixir.DbixirWeb
  alias Dbixir.DbixirWeb.Connection

  action_fallback DbixirWeb.FallbackController

  def index(conn, _params) do
    connections = DbixirWeb.list_connections()
    render(conn, "index.json", connections: connections)
  end

  def create(conn, %{"connection" => connection_params}) do
    with {:ok, %Connection{} = connection} <- DbixirWeb.create_connection(connection_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", connection_path(conn, :show, connection))
      |> render("show.json", connection: connection)
    end
  end

  def show(conn, %{"id" => id}) do
    connection = DbixirWeb.get_connection!(id)
    render(conn, "show.json", connection: connection)
  end

  def update(conn, %{"id" => id, "connection" => connection_params}) do
    connection = DbixirWeb.get_connection!(id)

    with {:ok, %Connection{} = connection} <- DbixirWeb.update_connection(connection, connection_params) do
      render(conn, "show.json", connection: connection)
    end
  end

  def delete(conn, %{"id" => id}) do
    connection = DbixirWeb.get_connection!(id)
    with {:ok, %Connection{}} <- DbixirWeb.delete_connection(connection) do
      send_resp(conn, :no_content, "")
    end
  end

  def option(conn, _params) do
    true
  end
end
