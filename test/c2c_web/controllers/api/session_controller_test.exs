defmodule C2cWeb.Api.SessionControllerTest do
  use C2cWeb.ConnCase, async: true

  # https://fullstackphoenix.com/tutorials/combining-authentication-solutions-with-guardian-and-phx-gen-auth
  import C2c.AccountsFixtures

  setup do
    %{user: user_fixture()}
  end

  describe "POST /api/session" do
    test "with no credentials user can't login", %{conn: conn} do
      conn = post(conn, Routes.api_session_path(conn, :create), %{session: %{email: nil, password: nil}})
      assert %{"message" => "User could not be authenticated"} = json_response(conn, 401)
    end

    test "with invalid password user cant login", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.api_session_path(conn, :create),
          %{session: %{ email: user.email,
          password: "wrongpass" }}
        )

      assert %{"message" => "User could not be authenticated"} = json_response(conn, 401)
    end

    test "with valid password user can login", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.api_session_path(conn, :create),
          %{session: %{ email: user.email,
          password: valid_user_password()}}
        )

      assert %{
               "data" => %{"token" => "" <> _},
               "message" => "You are successfully logged in" <> _
             } = json_response(conn, 200)
    end
  end
end
