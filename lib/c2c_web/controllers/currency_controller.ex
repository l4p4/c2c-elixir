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
    security([%{Bearer: []}])

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
    security([%{Bearer: []}])

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
    security([%{Bearer: []}])

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
    security([%{Bearer: []}])

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
    security([%{Bearer: []}])
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

    if Guardian.Plug.authenticated?(conn) do
      render(conn, "index.json", currencies: currencies)
    else
      render(conn, "index.html", currencies: currencies)
    end
  end

  def new(conn, _params) do
    changeset = Currencies.change_currency(%Currency{})

    if Guardian.Plug.authenticated?(conn) do
      render(conn, "new.json", changeset: changeset)
    else
      render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, %{"currency" => currency_params}) do
    if Guardian.Plug.authenticated?(conn) do
      case Currencies.create_currency(currency_params) do
        {:ok, currency} ->
          conn
          |> put_status(:created)
          |> render("show.json", currency: currency)

        {:error, %Ecto.Changeset{} = _changeset} ->
          conn
          |> put_status(400)
          |> render("error.json", message: "Currency could not be created, malformed data")
      end
    else
      case Currencies.create_currency(currency_params) do
        {:ok, currency} ->
          conn
          |> put_flash(:info, "Currency created successfully.")
          |> redirect(to: Routes.currency_path(conn, :show, currency))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    currency = Currencies.get_currency!(id)

    if Guardian.Plug.authenticated?(conn) do
      render(conn, "show.json", currency: currency)
    else
      render(conn, "show.html", currency: currency)
    end
  end

  def edit(conn, %{"id" => id}) do
    currency = Currencies.get_currency!(id)
    changeset = Currencies.change_currency(currency)

    if Guardian.Plug.authenticated?(conn) do
      render(conn, "edit.json", currency: currency, changeset: changeset)
    else
      render(conn, "edit.html", currency: currency, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "currency" => currency_params}) do
    currency = Currencies.get_currency!(id)

    if Guardian.Plug.authenticated?(conn) do
      case Currencies.update_currency(currency, currency_params) do
        {:ok, currency} ->
          conn
          |> put_status(200)
          |> redirect(to: Routes.currency_path(conn, :show, currency))

        {:error, %Ecto.Changeset{} = _changeset} ->
          conn
          |> put_status(400)
          |> render("error.json", message: "Currency could not be updated. Invalid data type.")
      end
    else
      case Currencies.update_currency(currency, currency_params) do
        {:ok, currency} ->
          conn
          |> put_flash(:info, "Currency updated successfully.")
          |> redirect(to: Routes.currency_path(conn, :show, currency))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", currency: currency, changeset: changeset)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    currency = Currencies.get_currency!(id)
    {:ok, _currency} = Currencies.delete_currency(currency)

    if Guardian.Plug.authenticated?(conn) do
      conn
      |> put_status(200)
      |> redirect(to: Routes.currency_path(conn, :index))
    else
      conn
      |> put_flash(:info, "Currency deleted successfully.")
      |> redirect(to: Routes.currency_path(conn, :index))
    end
  end
end
