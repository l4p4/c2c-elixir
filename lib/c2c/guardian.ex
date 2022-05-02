defmodule C2c.Guardian do
  @moduledoc """
    The module to configure auth for jwt tokens.
  """
  use Guardian, otp_app: :c2c

  alias C2c.Accounts

  def subject_for_token(user, _claims) do
    sub = to_string(user.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    resource = Accounts.get_user!(id)
    {:ok, resource}
  end
end
