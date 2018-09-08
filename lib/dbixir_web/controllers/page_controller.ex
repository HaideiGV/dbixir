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

  def add_new_connection(%Plug.Conn{method: method, body_params: body_params, cookies: cookies} = conn, _params) do
    %{
      "username" => username, 
      "host" => host, 
      "port" => port, 
      "db_adapter" => db_adapter,
      "db_name" => db_name, 
      "password" => password
    } = body_params

    connection_pid_name = cookies |> Map.get("user_connection")
    
    pid = get_connection_pid_by_name(connection_pid_name)

    if pid do
      render conn, "notification.html", message: "Connection already inititalized for (#{db_name}) database."
    else
      {:ok, user_conn_pid} = Postgrex.start_link(
        username: username, password: password, port: port, hostname: host, database: db_name
      )
      
      cookie_atom = gen_cookie_atom(username, db_name)
      Process.register(user_conn_pid, cookie_atom)

      conn = put_resp_cookie(conn, "user_connection", Atom.to_string(cookie_atom))

      render conn, "notification.html", message: "Connection was inititalized for (#{db_name}) database."
    end
  end

  def get_table_list(%Plug.Conn{cookies: cookies} = conn, _params) do
    connection_pid_name = cookies |> Map.get("user_connection")
    pid = get_connection_pid_by_name(connection_pid_name)

    if pid do
      {:ok, %Postgrex.Result{rows: rows}} = Postgrex.query(
        pid, "select * from pg_catalog.pg_tables where schemaname = 'public';", []
      )
      tables = Enum.map(rows, fn row -> Enum.at(row, 1) end)
      render conn, "table_list.html", tables: tables
    else
      render conn, "notification.html", message: "Connection failed. Try to reconnect."
    end
  end

  def show_query_area(conn, _params) do
    render conn, "query_area.html"
  end

  def query_execute(conn, _params) do
    render conn, "query_area.html"
  end

end
