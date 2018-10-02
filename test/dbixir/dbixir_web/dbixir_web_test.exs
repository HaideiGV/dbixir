defmodule Dbixir.DbixirWebTest do
  use Dbixir.DataCase

  alias Dbixir.DbixirWeb

  describe "connections" do
    alias Dbixir.DbixirWeb.Connection

    @valid_attrs %{db_name: "some db_name", hostname: "some hostname", name: "some name", password: "some password", port: 42, username: "some username"}
    @update_attrs %{db_name: "some updated db_name", hostname: "some updated hostname", name: "some updated name", password: "some updated password", port: 43, username: "some updated username"}
    @invalid_attrs %{db_name: nil, hostname: nil, name: nil, password: nil, port: nil, username: nil}

    def connection_fixture(attrs \\ %{}) do
      {:ok, connection} =
        attrs
        |> Enum.into(@valid_attrs)
        |> DbixirWeb.create_connection()

      connection
    end

    test "list_connections/0 returns all connections" do
      connection = connection_fixture()
      assert DbixirWeb.list_connections() == [connection]
    end

    test "get_connection!/1 returns the connection with given id" do
      connection = connection_fixture()
      assert DbixirWeb.get_connection!(connection.id) == connection
    end

    test "create_connection/1 with valid data creates a connection" do
      assert {:ok, %Connection{} = connection} = DbixirWeb.create_connection(@valid_attrs)
      assert connection.db_name == "some db_name"
      assert connection.hostname == "some hostname"
      assert connection.name == "some name"
      assert connection.password == "some password"
      assert connection.port == 42
      assert connection.username == "some username"
    end

    test "create_connection/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = DbixirWeb.create_connection(@invalid_attrs)
    end

    test "update_connection/2 with valid data updates the connection" do
      connection = connection_fixture()
      assert {:ok, connection} = DbixirWeb.update_connection(connection, @update_attrs)
      assert %Connection{} = connection
      assert connection.db_name == "some updated db_name"
      assert connection.hostname == "some updated hostname"
      assert connection.name == "some updated name"
      assert connection.password == "some updated password"
      assert connection.port == 43
      assert connection.username == "some updated username"
    end

    test "update_connection/2 with invalid data returns error changeset" do
      connection = connection_fixture()
      assert {:error, %Ecto.Changeset{}} = DbixirWeb.update_connection(connection, @invalid_attrs)
      assert connection == DbixirWeb.get_connection!(connection.id)
    end

    test "delete_connection/1 deletes the connection" do
      connection = connection_fixture()
      assert {:ok, %Connection{}} = DbixirWeb.delete_connection(connection)
      assert_raise Ecto.NoResultsError, fn -> DbixirWeb.get_connection!(connection.id) end
    end

    test "change_connection/1 returns a connection changeset" do
      connection = connection_fixture()
      assert %Ecto.Changeset{} = DbixirWeb.change_connection(connection)
    end
  end
end
