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
            url: "some url"
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
          url: "some url"
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
          url: "some url"
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
            url: "some url"
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
          url: "some url"
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
            limit(:string, "ApiCurrency limit")
            remaining_conversions(:string, "ApiCurrency remaining_conversions")
            url(:string, "ApiCurrency url")
          end

          example(%{
            id: 123,
            api_key: "some api_key",
            description: "some description",
            limit: 42,
            remaining_conversions: 42,
            url: "some url"
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

  def index(conn, _params) do
    api_currencies = ApiCurrencies.list_api_currencies(conn.assigns.current_user)
    render(conn, :index, api_currencies: api_currencies)
  end

  def new(conn, _params) do
    changeset = ApiCurrencies.change_api_currency(%ApiCurrency{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"api_currency" => api_currency_params}) do
    api_currency_params = Map.put(api_currency_params, "user_id", conn.assigns.current_user.id)

    case ApiCurrencies.create_api_currency(api_currency_params) do
      {:ok, api_currency} ->
        conn
        |> put_flash(:info, "Api currency created successfully.")
        |> redirect(to: Routes.api_currency_path(conn, :show, api_currency))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    api_currency = ApiCurrencies.get_api_currency!(conn.assigns.current_user, id)
    render(conn, :show, api_currency: api_currency)
  end

  def edit(conn, %{"id" => id}) do
    api_currency = ApiCurrencies.get_api_currency!(conn.assigns.current_user, id)
    changeset = ApiCurrencies.change_api_currency(api_currency)
    render(conn, :edit, api_currency: api_currency, changeset: changeset)
  end

  def update(conn, %{"id" => id, "api_currency" => api_currency_params}) do
    api_currency = ApiCurrencies.get_api_currency!(conn.assigns.current_user, id)

    case ApiCurrencies.update_api_currency(api_currency, api_currency_params) do
      {:ok, api_currency} ->
        conn
        |> put_flash(:info, "Api currency updated successfully.")
        |> redirect(to: Routes.api_currency_path(conn, :show, api_currency))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, api_currency: api_currency, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    api_currency = ApiCurrencies.get_api_currency!(conn.assigns.current_user, id)
    {:ok, _api_currency} = ApiCurrencies.delete_api_currency(api_currency)

    conn
    |> put_flash(:info, "Api currency deleted successfully.")
    |> redirect(to: Routes.api_currency_path(conn, :index))
  end
end
