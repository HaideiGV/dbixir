defmodule Dbixir.Helpers do

    def gen_cookie_atom(username, dbname) do
        "cookie_#{username}_#{dbname}" |> String.to_atom
    end

    def get_session_pid_by_name(cookies) do
        conn_atom = Map.get(cookies, "user_session") 
        if conn_atom do
            Process.registered()
            |> Enum.filter(fn pid_name -> pid_name == String.to_atom(conn_atom) end)
            |> List.first
        else
            nil
        end
    end
end