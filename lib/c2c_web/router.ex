defmodule C2cWeb.Router do
  use C2cWeb, :router

  import C2cWeb.UserAuth

  pipeline :browser do
    plug(:accepts, ["html", "json"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {C2cWeb.LayoutView, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:fetch_current_user)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  # JWT API Authenticate
  pipeline :jwt_authenticated do
    plug(C2cWeb.AuthAccessPipeline)
  end

  ## Control browser authenticated

  scope "/", C2cWeb do
    pipe_through([:browser, :require_authenticated_user])

    resources("/currencies", CurrencyController)
    resources("/api_currencies", ApiCurrencyController)
    resources("/transactions", TransactionController)
  end
  
  scope "/api", C2cWeb, as: :api do
    pipe_through(:jwt_authenticated)

    resources("/currencies", CurrencyController)
    resources("/api_currencies", ApiCurrencyController)
    resources("/transactions", TransactionController)
    post("/convert", TransactionController, :convert)
    get("/my_session", Api.SessionController, :show)
  end

  scope "/api", C2cWeb, as: :api do
    pipe_through(:api)

    post("/sign_in", Api.SessionController, :create)
    resources("/currencies", CurrencyController)
    resources("/api_currencies", ApiCurrencyController)
    resources("/transactions", TransactionController)
    post("/convert", TransactionController, :convert)
  end

  # Free access index page
  scope "/", C2cWeb do
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  # Other scopes may use custom stacks.
  # scope "/api", C2cWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: C2cWeb.Telemetry)
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through(:browser)

      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end

  ## Authentication routes

  scope "/", C2cWeb do
    pipe_through([:browser, :redirect_if_user_is_authenticated])

    get("/users/register", UserRegistrationController, :new)
    post("/users/register", UserRegistrationController, :create)
    get("/users/log_in", UserSessionController, :new)
    post("/users/log_in", UserSessionController, :create)
    get("/users/reset_password", UserResetPasswordController, :new)
    post("/users/reset_password", UserResetPasswordController, :create)
    get("/users/reset_password/:token", UserResetPasswordController, :edit)
    put("/users/reset_password/:token", UserResetPasswordController, :update)
  end

  scope "/", C2cWeb do
    pipe_through([:browser, :require_authenticated_user])

    get("/users/settings", UserSettingsController, :edit)
    put("/users/settings", UserSettingsController, :update)
    get("/users/settings/confirm_email/:token", UserSettingsController, :confirm_email)
  end

  scope "/", C2cWeb do
    pipe_through([:browser])

    delete("/users/log_out", UserSessionController, :delete)
    get("/users/confirm", UserConfirmationController, :new)
    post("/users/confirm", UserConfirmationController, :create)
    get("/users/confirm/:token", UserConfirmationController, :edit)
    post("/users/confirm/:token", UserConfirmationController, :update)
  end

  # Swagger
  scope "/api/swagger" do
    forward("/", PhoenixSwagger.Plug.SwaggerUI,
      otp_app: :c2c,
      swagger_file: "swagger.json"
    )
  end

  def swagger_info do
    %{
      schemes: ["https", "http"],
      info: %{
        version: "1.0",
        title: "C2cWeb",
        description: "API Documentation for C2cWeb v1",
        termsOfService: "Open for public",
        contact: %{
          name: "Larry Pavanery",
          email: "pavanery@gmail.com"
        }
      },
      securityDefinitions: %{
        Bearer: %{
          type: "apiKey",
          name: "Authorization",
          description: "API Token must be provided via `Authorization: Bearer ` header",
          in: "header"
        }
      },
      consumes: ["application/json"],
      produces: ["application/json"]
    }
  end
end
