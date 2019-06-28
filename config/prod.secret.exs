use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :dbixir, DbixirWeb.Endpoint,
  secret_key_base: "I+ToCPrjSDPEOXSYs+YIsSO0NRF19AzYSN5VnmSfEVpArTDjLGwHB/G5Id9v8gRL"

# Configure your database
config :dbixir, Dbixir.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "dbixir_prod",
  pool_size: 15
