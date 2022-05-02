defmodule C2cWeb.ApiCurrencyController do
  use C2cWeb, :controller

  alias C2c.ApiCurrencies
  alias C2c.ApiCurrencies.ApiCurrency

  use PhoenixSwagger

  swagger_path :index do
    get("/api/api_currencies")
    summary("List api_currencies")
    description("List all api_currencies in the database")
    tag("ApiCurrencys")
    produces("application/json")
    security([%{Bearer: []}])

    response(200, "OK", Schema.ref(:ApiCurrencysResponse),
      example: %{
        data: [
          %{
            id: 1,
            api_key: "some api_key",
            description: "some description",
            limit: 42,
            remaining_conversions: 42,
            url: "some url",
            user_id: 2
          }
        ]
      }
    )
  end

  swagger_path :create do
    post("/api/api_currencies")
    summary("Create api_currency")
    description("Creates a new api_currency")
    tag("ApiCurrencys")
    consumes("application/json")
    produces("application/json")
    security([%{Bearer: []}])

    parameter(:api_currency, :body, Schema.ref(:ApiCurrencyRequest), "The api_currency details",
      example: %{
        api_currency: %{
          api_key: "some api_key",
          description: "some description",
          limit: 42,
          remaining_conversions: 42,
          url: "some url"
        }
      }
    )

    response(201, "ApiCurrency created OK", Schema.ref(:ApiCurrencyResponse),
      example: %{
        data: %{
          id: 1,
          api_key: "some api_key",
          description: "some description",
          limit: 42,
          remaining_conversions: 42,
          url: "some url",
          user_id: 2
        }
      }
    )
  end

  swagger_path :show do
    get("/api/api_currencies/{id}")
    summary("Show ApiCurrency")
    description("Show a api_currency by ID")
    tag("ApiCurrencys")
    produces("application/json")
    parameter(:id, :path, :integer, "ApiCurrency ID", required: true, example: 123)
    security([%{Bearer: []}])

    response(200, "OK", Schema.ref(:ApiCurrencyResponse),
      example: %{
        data: %{
          id: 123,
          api_key: "some api_key",
          description: "some description",
          limit: 42,
          remaining_conversions: 42,
          url: "some url",
          user_id: 2
        }
      }
    )
  end

  swagger_path :update do
    put("/api/api_currencies/{id}")
    summary("Update api_currency")
    description("Update all attributes of a api_currency")
    tag("ApiCurrencys")
    consumes("application/json")
    produces("application/json")
    security([%{Bearer: []}])

    parameters do
      id(:path, :integer, "ApiCurrency ID", required: true, example: 3)

      api_currency(:body, Schema.ref(:ApiCurrencyRequest), "The api_currency details",
        example: %{
          api_currency: %{
            api_key: "some api_key",
            description: "some description",
            limit: 42,
            remaining_conversions: 42,
            url: "some url",
            user_id: 2
          }
        }
      )
    end

    response(200, "Updated Successfully", Schema.ref(:ApiCurrencyResponse),
      example: %{
        data: %{
          id: 3,
          api_key: "some api_key",
          description: "some description",
          limit: 42,
          remaining_conversions: 42,
          url: "some url",
          user_id: 2
        }
      }
    )
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/api/api_currencies/{id}")
    summary("Delete ApiCurrency")
    description("Delete a api_currency by ID")
    tag("ApiCurrencys")
    parameter(:id, :path, :integer, "ApiCurrency ID", required: true, example: 3)
    response(203, "No Content - Deleted Successfully")
    security([%{Bearer: []}])
  end

  def swagger_definitions do
    %{
      ApiCurrency:
        swagger_schema do
          title("ApiCurrency")
          description("A api_currency of the app")

          properties do
            id(:integer, "ApiCurrency ID")
            api_key(:string, "ApiCurrency api_key")
            description(:string, "ApiCurrency description")
            limit(:integer, "ApiCurrency limit")
            remaining_conversions(:integer, "ApiCurrency remaining_conversions")
            url(:string, "ApiCurrency url")
            user_id(:integer, "ApiCurrency user_id")
          end

          example(%{
            id: 123,
            api_key: "some api_key",
            description: "some description",
            limit: 42,
            remaining_conversions: 42,
            url: "some url",
            user_id: 2
          })
        end,
      ApiCurrencyRequest:
        swagger_schema do
          title("ApiCurrencyRequest")
          description("POST body for creating a api_currency")
          property(:api_currency, Schema.ref(:ApiCurrency), "The api_currency details")

          example(%{
            api_currency: %{
              api_key: "some api_key",
              description: "some description",
              limit: 42,
              remaining_conversions: 42,
              url: "some url"
            }
          })
        end,
      ApiCurrencyResponse:
        swagger_schema do
          title("ApiCurrencyResponse")
          description("Response schema for single api_currency")
          property(:data, Schema.ref(:ApiCurrency), "The api_currency details")
        end,
      ApiCurrencysResponse:
        swagger_schema do
          title("ApiCurrencyResponse")
          description("Response schema for multiple api_currencies")
          property(:data, Schema.array(:ApiCurrency), "The api_currencies details")
        end
    }
  end

  action_fallback(C2cWeb.FallbackController)

  def index(conn, _params) do
    if Guardian.Plug.authenticated?(conn) do
      render(conn, "index.json",
        api_currencies: ApiCurrencies.list_api_currencies(Guardian.Plug.current_resource(conn))
      )
    else
      render(conn, "index.html",
        api_currencies: ApiCurrencies.list_api_currencies(conn.assigns.current_user)
      )
    end
  end

  def new(conn, _params) do
    changeset = ApiCurrencies.change_api_currency(%ApiCurrency{})

    if Guardian.Plug.authenticated?(conn) do
      render(conn, "new.json", changeset: changeset)
    else
      render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, %{"api_currency" => api_currency_params}) do
    if Guardian.Plug.authenticated?(conn) do
      api_currency_params =
        Map.put(api_currency_params, "user_id", Guardian.Plug.current_resource(conn).id)

      case ApiCurrencies.create_api_currency(api_currency_params) do
        {:ok, api_currency} ->
          conn
          |> put_status(:created)
          |> render("show.json", api_currency: api_currency)

        {:error, %Ecto.Changeset{} = _changeset} ->
          conn
          |> put_status(400)
          |> render("error.json", message: "ApiCurrency could not be created, malformed data")
      end
    else
      api_currency_params = Map.put(api_currency_params, "user_id", conn.assigns.current_user.id)

      case ApiCurrencies.create_api_currency(api_currency_params) do
        {:ok, api_currency} ->
          conn
          |> put_flash(:info, "Api currency created successfully.")
          |> redirect(to: Routes.api_currency_path(conn, :show, api_currency))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    if Guardian.Plug.authenticated?(conn) do
      render(conn, "show.json",
        api_currency: ApiCurrencies.get_api_currency!(Guardian.Plug.current_resource(conn), id)
      )
    else
      render(conn, "show.html",
        api_currency: ApiCurrencies.get_api_currency!(conn.assigns.current_user, id)
      )
    end
  end

  def edit(conn, %{"id" => id}) do
    if Guardian.Plug.authenticated?(conn) do
      api_currency = ApiCurrencies.get_api_currency!(Guardian.Plug.current_resource(conn), id)

      render(conn, "edit.json",
        api_currency: api_currency,
        changeset: ApiCurrencies.change_api_currency(api_currency)
      )
    else
      api_currency = ApiCurrencies.get_api_currency!(conn.assigns.current_user, id)

      render(conn, "edit.html",
        api_currency: api_currency,
        changeset: ApiCurrencies.change_api_currency(api_currency)
      )
    end
  end

  def update(conn, %{"id" => id, "api_currency" => api_currency_params}) do
    if Guardian.Plug.authenticated?(conn) do
      api_currency = ApiCurrencies.get_api_currency!(Guardian.Plug.current_resource(conn), id)

      case ApiCurrencies.update_api_currency(api_currency, api_currency_params) do
        {:ok, api_currency} ->
          conn
          |> put_status(200)
          |> redirect(to: Routes.api_currency_path(conn, :show, api_currency))

        {:error, %Ecto.Changeset{} = _changeset} ->
          conn
          |> put_status(400)
          |> render("error.json", message: "ApiCurrency could not be updated. Invalid data type.")
      end
    else
      api_currency = ApiCurrencies.get_api_currency!(conn.assigns.current_user, id)

      case ApiCurrencies.update_api_currency(api_currency, api_currency_params) do
        {:ok, api_currency} ->
          conn
          |> put_flash(:info, "Api currency updated successfully.")
          |> redirect(to: Routes.api_currency_path(conn, :show, api_currency))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", api_currency: api_currency, changeset: changeset)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    if Guardian.Plug.authenticated?(conn) do
      api_currency = ApiCurrencies.get_api_currency!(Guardian.Plug.current_resource(conn), id)
      {:ok, _api_currency} = ApiCurrencies.delete_api_currency(api_currency)

      conn
      |> put_status(200)
      |> redirect(to: Routes.api_currency_path(conn, :index))
    else
      api_currency = ApiCurrencies.get_api_currency!(conn.assigns.current_user, id)
      {:ok, _api_currency} = ApiCurrencies.delete_api_currency(api_currency)

      conn
      |> put_flash(:info, "Transaction deleted successfully.")
      |> redirect(to: Routes.api_currency_path(conn, :index))
    end
  end
end
