defmodule DbixirWeb.PageController do
  use DbixirWeb, :controller
  import Dbixir.Helpers
  import Postgrex

  def index(conn, _params) do
    render conn, "index.html"
  end

  def get_table_list(%Plug.Conn{cookies: cookies} = conn, _params) do
    pid = get_connection_pid_by_name(cookies)

    if pid do
      {:ok, %Postgrex.Result{rows: rows}} = Postgrex.query(
        pid, "select * from pg_catalog.pg_tables where schemaname = 'public';", []
      )
      result = Enum.map(rows, fn row -> Enum.at(row, 1) end)
      render conn, "table_list.html", result: result
    else
      conn = conn |> put_flash(:error, "Connection failed. Try to reconnect.")
      render conn, "table_list.html", result: []
    end
  end

end
