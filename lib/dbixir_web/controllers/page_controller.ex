defmodule DbixirWeb.PageController do
  use DbixirWeb, :controller
  import Dbixir.Helpers
  import Postgrex

  def index(conn, _params) do
    render conn, "index.html"
  end

  def show_new_connection_page(conn, _params) do
    render conn, "new_connection.html"
  end

  def add_new_connection(%Plug.Conn{body_params: body_params, cookies: cookies} = conn, _params) do
    %{
      "username" => username, "host" => host, 
      "port" => port, "db_name" => db_name, "password" => password
    } = body_params
    
    pid = get_connection_pid_by_name(cookies)

    if pid do
      conn = put_flash(conn, :info, "Connection already inititalized for (#{db_name}) database.")
      render conn, "new_connection.html" 
    else
      {:ok, user_conn_pid} = Postgrex.start_link(
        username: username, password: password, port: port, hostname: host, database: db_name, timeout: 5000
      )
      
      cookie_atom = gen_cookie_atom(username, db_name)
      Process.register(user_conn_pid, cookie_atom)

      conn = conn
      |> put_flash(:info, "Connection was inititalized for (#{db_name}) database.")
      |> put_resp_cookie("user_connection", Atom.to_string(cookie_atom))
      
      render conn, "new_connection.html" 
    end
  end

  def disconnect(%Plug.Conn{cookies: cookies} = conn, _params) do
    pid = get_connection_pid_by_name(cookies)
    if pid do
      Process.unregister(pid)
      conn = conn
      |> put_flash(:info, "Disconnected.")
      |> put_resp_cookie("user_connection", "")
      render conn, "new_connection.html"
    else
      conn = conn |> put_flash(:info, "Already disconnected.")
      render conn, "new_connection.html"
    end
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

  def show_query_area(conn, _params) do
    render conn, "query_area.html", query_string: "", rows: [], columns: []
  end

  def query_execute(%Plug.Conn{body_params: body_params, cookies: cookies} = conn, _params) do
    pid = get_connection_pid_by_name(cookies)

    if pid do
      query_string = Map.get(body_params, "query-string")
      if query_string do
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
