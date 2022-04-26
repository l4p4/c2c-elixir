defmodule C2c.Repo do
  use Ecto.Repo,
    otp_app: :c2c,
    adapter: Ecto.Adapters.Postgres
end
