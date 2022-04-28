defmodule C2cWeb.CurrencyController do
  use C2cWeb, :controller

  alias C2c.Currencies
  alias C2c.Currencies.Currency

  use PhoenixSwagger

  swagger_path :index do
    get("/api/currencies")
    summary("List currencies")
    description("List all currencies in the database")
    tag("Currencys")
    produces("application/json")

    response(200, "OK", Schema.ref(:CurrencysResponse),
      example: %{
        data: [
          %{
            id: 1,
            name: "some name"
          }
        ]
      }
    )
  end

  swagger_path :create do
    post("/api/currencies")
    summary("Create currency")
    description("Creates a new currency")
    tag("Currencys")
    consumes("application/json")
    produces("application/json")

    parameter(:currency, :body, Schema.ref(:CurrencyRequest), "The currency details",
      example: %{
        currency: %{name: "some name"}
      }
    )

    response(201, "Currency created OK", Schema.ref(:CurrencyResponse),
      example: %{
        data: %{
          id: 1,
          name: "some name"
        }
      }
    )
  end

  swagger_path :show do
    get("/api/currencies/{id}")
    summary("Show Currency")
    description("Show a currency by ID")
    tag("Currencys")
    produces("application/json")
    parameter(:id, :path, :integer, "Currency ID", required: true, example: 123)

    response(200, "OK", Schema.ref(:CurrencyResponse),
      example: %{
        data: %{
          id: 123,
          name: "some name"
        }
      }
    )
  end

  swagger_path :update do
    put("/api/currencies/{id}")
    summary("Update currency")
    description("Update all attributes of a currency")
    tag("Currencys")
    consumes("application/json")
    produces("application/json")

    parameters do
      id(:path, :integer, "Currency ID", required: true, example: 3)

      currency(:body, Schema.ref(:CurrencyRequest), "The currency details",
        example: %{
          currency: %{name: "some name"}
        }
      )
    end

    response(200, "Updated Successfully", Schema.ref(:CurrencyResponse),
      example: %{
        data: %{
          id: 3,
          name: "some name"
        }
      }
    )
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/api/currencies/{id}")
    summary("Delete Currency")
    description("Delete a currency by ID")
    tag("Currencys")
    parameter(:id, :path, :integer, "Currency ID", required: true, example: 3)
    response(203, "No Content - Deleted Successfully")
  end

  def swagger_definitions do
    %{
      Currency:
        swagger_schema do
          title("Currency")
          description("A currency of the app")

          properties do
            id(:integer, "Currency ID")
            name(:string, "Currency name")
          end

          example(%{
            id: 123,
            name: "some name"
          })
        end,
      CurrencyRequest:
        swagger_schema do
          title("CurrencyRequest")
          description("POST body for creating a currency")
          property(:currency, Schema.ref(:Currency), "The currency details")

          example(%{
            currency: %{
              name: "some name"
            }
          })
        end,
      CurrencyResponse:
        swagger_schema do
          title("CurrencyResponse")
          description("Response schema for single currency")
          property(:data, Schema.ref(:Currency), "The currency details")
        end,
      CurrencysResponse:
        swagger_schema do
          title("CurrencyResponse")
          description("Response schema for multiple currencies")
          property(:data, Schema.array(:Currency), "The currencies details")
        end
    }
  end

  def index(conn, _params) do
    currencies = Currencies.list_currencies()
    render(conn, :index, currencies: currencies)
  end

  def new(conn, _params) do
    changeset = Currencies.change_currency(%Currency{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"currency" => currency_params}) do
    case Currencies.create_currency(currency_params) do
      {:ok, currency} ->
        conn
        |> put_flash(:info, "Currency created successfully.")
        |> redirect(to: Routes.currency_path(conn, :show, currency))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    currency = Currencies.get_currency!(id)
    render(conn, :show, currency: currency)
  end

  def edit(conn, %{"id" => id}) do
    currency = Currencies.get_currency!(id)
    changeset = Currencies.change_currency(currency)
    render(conn, "edit.html", currency: currency, changeset: changeset)
  end

  def update(conn, %{"id" => id, "currency" => currency_params}) do
    currency = Currencies.get_currency!(id)

    case Currencies.update_currency(currency, currency_params) do
      {:ok, currency} ->
        conn
        |> put_flash(:info, "Currency updated successfully.")
        |> redirect(to: Routes.currency_path(conn, :show, currency))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", currency: currency, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    currency = Currencies.get_currency!(id)
    {:ok, _currency} = Currencies.delete_currency(currency)

    conn
    |> put_flash(:info, "Currency deleted successfully.")
    |> redirect(to: Routes.currency_path(conn, :index))
  end
end
