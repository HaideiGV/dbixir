defmodule DbixirWeb.SessionController do
  use DbixirWeb, :controller
  import Dbixir.Helpers
  import Postgrex

  def new_session(conn, _params) do
    render conn, "new_session.html"
  end

  def open_session(%Plug.Conn{body_params: body_params, cookies: cookies} = conn, _params) do
    %{
      "username" => username, 
      "host" => host, 
      "port" => port, 
      "db_name" => db_name, 
      "password" => password
    } = body_params
    
    pid = get_session_pid_by_name(cookies)

    if pid do
      conn = put_flash(conn, :info, "Session already inititalized for (#{db_name}) database.")
      render conn, "new_session.html" 
    else
      {:ok, user_session_pid} = Postgrex.start_link(
        username: username, 
        password: password, 
        port: port, 
        hostname: host, 
        database: db_name, 
        timeout: 5000
      )
      
      cookie_atom = gen_cookie_atom(username, db_name)
      Process.register(user_session_pid, cookie_atom)

      conn = conn
      |> put_flash(:info, "Session was inititalized for (#{db_name}) database.")
      |> put_resp_cookie("user_session", Atom.to_string(cookie_atom))
      
      render conn, "new_session.html" 
    end
  end

  def close_session(%Plug.Conn{cookies: cookies} = conn, _params) do
    pid = get_session_pid_by_name(cookies)
    if pid do
      Process.unregister(pid)
      conn = conn
      |> put_flash(:info, "Closed session.")
      |> put_resp_cookie("user_session", "")
      render conn, "new_session.html"
    else
      conn = conn |> put_flash(:info, "Already closed session.")
      render conn, "new_session.html"
    end
  end

end
