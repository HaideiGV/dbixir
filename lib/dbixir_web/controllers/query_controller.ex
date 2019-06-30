defmodule DbixirWeb.QueryController do
  use DbixirWeb, :controller
  import Dbixir.Helpers
  import Postgrex

  def show_query_area(conn, _params) do
    render conn, "query_area.html", query_string: "", rows: [], columns: []
  end

  def query_execute(%Plug.Conn{body_params: body_params, cookies: cookies} = conn, _params) do
    pid = get_session_pid_by_name(cookies)

    if pid do
      query_string = Map.get(body_params, "query-string") |> String.trim
      if query_string != "" do
        query = Postgrex.prepare!(pid, "", query_string)
        {:ok, %Postgrex.Result{rows: rows, columns: columns}} = Postgrex.execute(pid, query, [])
        render conn, "query_area.html", rows: rows, columns: columns, query_string: query_string
      else
        conn = conn |> put_flash(:error, "Query string is empty.")
        render conn, "query_area.html", rows: [], columns: [], query_string: ""
      end
    else
      conn = conn |> put_flash(:error, "Connection failed. Try to reconnect.")
      render conn, "query_area.html", rows: [], columns: [], query_string: ""
    end
  end

end
