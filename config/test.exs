import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :c2c, C2c.Repo,
  username: "postgres",
  password: "postgres",
  hostname: System.get_env("DB_HOST", "localhost"),
  database: "c2c_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :c2c, C2cWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "j+yqWEB7lDzS1wjsXWsTLicSSKNYN8C6Wkx3dXlWG2aqS/D9XlCJ0xZBGk1xaH8q",
  server: false

# In test we don't send emails.
config :c2c, C2c.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn, backends: [:console]

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
