defmodule C2cWeb.Api.SessionView do
  use C2cWeb, :view

  def render("create.json", %{user: user, jwt: jwt}) do
    %{
      status: :ok,
      data: %{
        token: jwt,
        email: user.email
      },
      message:
        "You are successfully logged in! Add this token to authorization header to make authorized requests."
    }
  end

  def render("error.json", %{message: message}) do
    %{
      status: :not_found,
      data: %{},
      message: message
    }
  end

  def render("user.json", %{user: user}) do
    %{
      status: :ok,
      data: %{
        email: user.email
      },
      message: "Hi there!"
    }
  end
end
