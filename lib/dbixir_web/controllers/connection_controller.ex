defmodule DbixirWeb.ConnectionController do
  use DbixirWeb, :controller
  import Dbixir.Helpers
  import Postgrex

  def show_new_connection_page(conn, _params) do
    render conn, "new_connection.html"
  end

  def add_new_connection(%Plug.Conn{body_params: body_params, cookies: cookies} = conn, _params) do
    %{
      "username" => username, 
      "host" => host, 
      "port" => port, 
      "db_name" => db_name, 
      "password" => password
    } = body_params
    
    pid = get_connection_pid_by_name(cookies)

    if pid do
      conn = put_flash(conn, :info, "Connection already inititalized for (#{db_name}) database.")
      render conn, "new_connection.html" 
    else
      {:ok, user_conn_pid} = Postgrex.start_link(
        username: username, 
        password: password, 
        port: port, 
        hostname: host, 
        database: db_name, 
        timeout: 5000
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

end
