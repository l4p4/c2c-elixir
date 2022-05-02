defmodule C2cWeb.Api.SessionController do
  use C2cWeb, :controller

  alias C2c.Accounts
  alias C2c.Accounts.User
  alias C2c.Guardian

  use PhoenixSwagger

  swagger_path :create do
    post("/api/sign_in")
    summary("Get a JWT token")
    description("Return a JWT token to perform over restFul API")
    tag("JWT Token")
    consumes("application/json")
    produces("application/json")

    parameter(:currency, :body, Schema.ref(:SessionRequest), "The session details",
      example: %{
        email: "admin@admin",
        password: "supersecret"
      }
    )

    response(201, "JWT token created OK", Schema.ref(:CurrencyResponse),
      example: %{
        data: %{
          email: "admin@admin",
          token:
            "eyJhbGciOiJIUzUxMinR5cCI6IkpXVCJ9.eyJhdWQiOiJjMmMiLCJleHAiOjE2NTE3MDk5NTksImlhdCI6MTY1MTQoiYzJjIiwianRpIjoiZGViYmM0NWUtM2Y5Mi00MzUwLWE5YzQtNzQ1NmRhOGUzZWQ2IiwibmJmIjoxNjUxNDUwNzU4LCJzdWIiOiIxIiwidHlwIjoiYWNjZXNzIn0.9jBM_UGzJnZ360nGftB7NZh_4_VJCyiLOb25xl3Gxu87OPARurwhSBREzunCr-K7fKp6EQ"
        },
        message:
          "You are successfully logged in! Add this token to authorization header to make authorized requests.",
        status: "ok"
      }
    )
  end

  swagger_path :show do
    get("/api/my_session")
    summary("Get email session by JWT token")
    description("Show a email from user by JWT token")
    tag("JWT Token")
    produces("application/json")

    parameter(:authorization, :header, :string, "JWT token",
      required: true,
      example: "Bearer saisjas98aHNauWCsRSHuaaornn...sdddDd"
    )

    response(200, "OK", Schema.ref(:SessionResponse),
      example: %{
        data: %{
          email: "admin@admin"
        },
        message: "Hi there!",
        status: "ok"
      }
    )
  end

  def swagger_definitions do
    %{
      Session:
        swagger_schema do
          title("Session")
          description("A session JWT token created by user")

          properties do
            email(:string, "Session email")
            password(:string, "Session password")
          end

          example(%{
            email: "admin@admin",
            password: "supersecret"
          })
        end,
      SessionRequest:
        swagger_schema do
          title("SessionRequest")
          description("POST body for get JWT token")
          property(:session, Schema.ref(:Session), "The session details")

          example(%{
            email: "admin@admin",
            password: "supersecret"
          })
        end,
      SessionReponse:
        swagger_schema do
          title("SessionResponse")
          description("Response schema for JWT token")
          property(:data, Schema.ref(:Session), "The session details")
        end
    }
  end

  def create(conn, %{"email" => nil}) do
    conn
    |> put_status(401)
    |> render("error.json", message: "User could not be authenticated")
  end

  def create(conn, %{"email" => email, "password" => password}) do
    case Accounts.get_user_by_email_and_password(email, password) do
      %User{} = user ->
        {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user, %{})

        conn
        |> render("create.json", user: user, jwt: jwt)

      nil ->
        conn
        |> put_status(401)
        |> render("error.json", message: "User could not be authenticated")
    end
  end

  def show(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    conn |> render("user.json", user: user)
  end
end
