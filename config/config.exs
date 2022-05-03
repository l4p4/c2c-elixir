# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :c2c,
  ecto_repos: [C2c.Repo]

# Configures the endpoint
config :c2c, C2cWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: C2cWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: C2c.PubSub,
  live_view: [signing_salt: "oIUIrPm1"]

# Guardian
config :c2c, C2c.Guardian,
  issuer: "c2c",
  secret_key: "Wp+FiImfPic9uUMlDCsqfbppH3JUsYFcI27fhE3wXjpxqVeI2pwGFe+iPA8q/Mpk",
  ttl: {3, :days}

config :c2c, C2cWeb.AuthAccessPipeline,
  module: C2c.Guardian,
  error_handler: C2cWeb.AuthErrorHandler

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :c2c, C2c.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Swagger
config :c2c, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      # phoenix routes will be converted to swagger paths
      router: C2cWeb.Router,
      # (optional) endpoint config used to set host, port and https schemes.
      endpoint: C2cWeb.Endpoint
    ]
  }

# Use Jason for JSON parsing in Phoenix Swagger
config :phoenix_swagger, json_library: Jason

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

if Mix.env() == :dev do
  config :git_hooks,
    auto_install: true,
    verbose: true,
    branches: [
      whitelist: ["master", "feature*", "fix*"]
      #      blacklist: ["master"]
    ],
    hooks: [
      pre_commit: [
        tasks: [
          {:cmd, "mix clean"},
          {:cmd, "mix compile"},
          {:cmd, "mix format"},
          {:cmd, "mix credo --strict"},
          {:cmd, "mix doctor --summary"},
          {:cmd, "mix test --color"}
        ]
      ],
      pre_push: [
        verbose: false,
        tasks: [
          {:cmd, "mix dialyzer"},
          {:cmd, "echo 'success!'"}
        ]
      ]
    ]
end