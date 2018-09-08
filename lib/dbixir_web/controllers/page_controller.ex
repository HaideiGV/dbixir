defmodule DbixirWeb.PageController do
  use DbixirWeb, :controller
  import Dbixir.Helpers
  import Postgrex

  def index(conn, _params) do
    render conn, "index.html"
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

    cookie_name = gen_cookie_name(username, db_name)
    
    {:ok, user_conn_pid} = Postgrex.start_link(
      username: username, password: password, port: port, hostname: host, database: db_name
    )
    
    cookie_atom = cookie_name |> String.to_atom
    
    Process.register(user_conn_pid, cookie_atom)

    updated_cookies = Map.put(cookies, "user_connection", cookie_name)
    conn = Map.put(conn, :cookies, updated_cookies)

    render conn, "notification.html", message: "Connection was inititalized."
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

end
