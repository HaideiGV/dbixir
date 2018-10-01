defmodule DbixirWeb.Router do
  use DbixirWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    # plug :protect_from_forgery
    plug :put_secure_browser_headers
    # plug DbixirWeb.AgentPlugin
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DbixirWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/tables", PageController, :get_table_list
    get "/query", QueryController, :show_query_area
    post "/execute", QueryController, :query_execute
    get "/new", ConnectionController, :show_new_connection_page
    post "/connections/new", ConnectionController, :add_new_connection
    get "/disconnect", ConnectionController, :disconnect
  end
end
