defmodule DbixirWeb.Router do
  use DbixirWeb, :router

  pipeline :browser do
    plug CORSPlug, origin: ["*"]
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    # plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug CORSPlug, origin: ["*"]
    plug :fetch_session
    plug :accepts, ["json"]
  end

  scope "/", DbixirWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/tables", PageController, :get_table_list
    get "/query", QueryController, :show_query_area
    post "/execute", QueryController, :query_execute
    get "/session/new", SessionController, :new_session
    post "/session/open", SessionController, :open_session
    get "/session/close", SessionController, :close_session
  end

  scope "/api/v1", DbixirWeb do
    pipe_through :api

    # resources "/connections", ConnectionController, only: [:create, :show]

    options "/connections", ConnectionController, :option
    post "/connections", ConnectionController, :create

    get "/tables", PageController, :get_tables_list_json

  end

end
