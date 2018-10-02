defmodule Dbixir.Connection do
  use Ecto.Schema
  import Ecto.Changeset


  schema "connections" do
    field :db_name, :string
    field :hostname, :string
    field :name, :string
    field :password, :string
    field :port, :integer
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(connection, attrs) do
    connection
    |> cast(attrs, [:name, :port, :hostname, :username, :password, :db_name])
    |> validate_required([:name, :port, :hostname, :username, :password, :db_name])
  end
end
