defmodule Dbixir.Repo.Migrations.CreateConnections do
  use Ecto.Migration

  def change do
    create table(:connections) do
      add :name, :string
      add :port, :integer
      add :hostname, :string
      add :username, :string
      add :password, :string
      add :db_name, :string

      timestamps()
    end

  end
end
