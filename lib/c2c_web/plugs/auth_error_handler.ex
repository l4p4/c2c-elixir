defmodule C2cWeb.AuthErrorHandler do
  @moduledoc """
    The module to configure auth errors for jwt tokens.
  """
  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, _reason}, _opts) do
    body = Jason.encode!(%{message: to_string(type)})
    send_resp(conn, 401, body)
  end
end
