defmodule DbixirWeb.AgentPlugin do
    import Plug.Conn
    
    def init(default), do: default

    def call(conn, _default) do
        state_pid = Map.get(conn, :assigns) |> Map.get(:state_pid)

        if state_pid === nil do
            {:ok, state_pid} = Agent.start_link(fn -> [] end)
            assign(conn, :state_pid, state_pid)
        else
            conn
        end
    end

    def call(conn, default), do: assign(conn, :state_pid, default)

end