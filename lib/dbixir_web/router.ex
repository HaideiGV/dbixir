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
    post "/connections/new", PageController, :add_new_connection
    get "/tables", PageController, :get_table_list
  end
end
