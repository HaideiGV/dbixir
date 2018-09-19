defmodule Dbixir.Helpers do
    
    def get_conn_pid_by_cookie(cookie) do
        cookie_atom = cookie |> String.to_atom
        pid_list = 
        Process.registered() 
        |> Enum.map(fn name -> name == cookie_atom end)
        |> List.first
    end

    def gen_cookie_atom(username, dbname) do
        "cookie_#{username}_#{dbname}" |> String.to_atom
    end

    def get_connection_pid_by_name(cookies) do
        connection_pid_name = cookies |> Map.get("user_connection")
        conn_atom = connection_pid_name |> String.to_atom
        Process.registered()
        |> Enum.filter(fn pid_name -> pid_name == conn_atom end)
        |> List.first
    end
end