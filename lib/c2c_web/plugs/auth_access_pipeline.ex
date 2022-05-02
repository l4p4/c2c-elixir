defmodule C2cWeb.AuthAccessPipeline do
  @moduledoc """
    The module to configure auth for jwt tokens.
  """
  use Guardian.Plug.Pipeline, otp_app: :c2c

  plug(Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"})
  plug(Guardian.Plug.EnsureAuthenticated)
  plug(Guardian.Plug.LoadResource, allow_blank: true)
end
