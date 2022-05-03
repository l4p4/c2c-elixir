defmodule C2cWeb.TransactionController do
  use C2cWeb, :controller

  alias C2c.ApiCurrencies
  alias C2c.Currencies
  alias C2c.CurrencyConverter
  alias C2c.Transactions
  alias C2c.Transactions.Transaction

  use PhoenixSwagger

  swagger_path :index do
    get("/api/transactions")
    summary("List transactions")
    description("List all transactions in the database")
    tag("Transactions")
    produces("application/json")
    security([%{Bearer: []}])

    response(200, "OK", Schema.ref(:TransactionsResponse),
      example: %{
        data: [
          %{
            id: 123,
            currency_from: 1,
            amount_from: 120.5,
            currency_to: 1,
            amount_to: 120.5,
            fee_convert: 1,
            user_id: 2,
            inserted_at: "2022-05-01T23:22:20"
          }
        ]
      }
    )
  end

  swagger_path :create do
    post("/api/transactions")
    summary("Create transaction")
    description("Creates a new transaction")
    tag("Transactions")
    consumes("application/json")
    produces("application/json")
    security([%{Bearer: []}])

    parameter(:transaction, :body, Schema.ref(:TransactionRequest), "The transaction details",
      example: %{
        transaction: %{
          currency_from: 1,
          amount_from: 120.5,
          currency_to: 1,
          amount_to: 120.5,
          fee_convert: 1
        }
      }
    )

    response(201, "Transaction created OK", Schema.ref(:TransactionResponse),
      example: %{
        data: %{
          id: 123,
          currency_from: 1,
          amount_from: 120.5,
          currency_to: 1,
          amount_to: 120.5,
          fee_convert: 1,
          user_id: 2,
          inserted_at: "2022-05-01T23:22:20"
        }
      }
    )
  end

  swagger_path :show do
    get("/api/transactions/{id}")
    summary("Show Transaction")
    description("Show a transaction by ID")
    tag("Transactions")
    produces("application/json")
    parameter(:id, :path, :integer, "Transaction ID", required: true, example: 123)
    security([%{Bearer: []}])

    response(200, "OK", Schema.ref(:TransactionResponse),
      example: %{
        data: %{
          id: 123,
          currency_from: 1,
          amount_from: 120.5,
          currency_to: 1,
          amount_to: 120.5,
          fee_convert: 1,
          user_id: 2,
          inserted_at: "2022-05-01T23:22:20"
        }
      }
    )
  end

  swagger_path :update do
    put("/api/transactions/{id}")
    summary("Update transaction")
    description("Update all attributes of a transaction")
    tag("Transactions")
    consumes("application/json")
    produces("application/json")
    security([%{Bearer: []}])

    parameters do
      id(:path, :integer, "Transaction ID", required: true, example: 3)

      transaction(:body, Schema.ref(:TransactionRequest), "The transaction details",
        example: %{
          transaction: %{
            id: 123,
            currency_from: 1,
            amount_from: 120.5,
            currency_to: 1,
            amount_to: 120.5,
            fee_convert: 1,
            user_id: 2,
            inserted_at: "2022-05-01T23:22:20"
          }
        }
      )
    end

    response(200, "Updated Successfully", Schema.ref(:TransactionResponse),
      example: %{
        data: %{
          id: 123,
          currency_from: 1,
          amount_from: 120.5,
          currency_to: 1,
          amount_to: 120.5,
          fee_convert: 1,
          user_id: 2,
          inserted_at: "2022-05-01T23:22:20"
        }
      }
    )
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/api/transactions/{id}")
    summary("Delete Transaction")
    description("Delete a transaction by ID")
    tag("Transactions")
    parameter(:id, :path, :integer, "Transaction ID", required: true, example: 3)
    response(203, "No Content - Deleted Successfully")
    security([%{Bearer: []}])
  end

  swagger_path :convert do
    post("/api/convert")
    summary("Convert amount")
    description("Convert a amount from currency to another")
    tag("Transactions")
    consumes("application/json")
    produces("application/json")
    security([%{Bearer: []}])

    parameter(:transaction, :body, Schema.ref(:ConvertRequest), "The convert details",
      example: %{
        transaction: %{
          currency_from: 1,
          amount_from: 1,
          currency_to: 2,
          api_currency: 1
        }
      }
    )

    response(201, "Transaction created OK", Schema.ref(:TransactionResponse),
      example: %{
        data: %{
          id: 123,
          currency_from: 1,
          amount_from: 120.5,
          currency_to: 1,
          amount_to: 120.5,
          fee_convert: 1,
          user_id: 2,
          inserted_at: "2022-05-01T23:22:20"
        }
      }
    )
  end

  def swagger_definitions do
    %{
      Transaction:
        swagger_schema do
          title("Transaction")
          description("A transaction of the app")

          properties do
            id(:integer, "Transaction ID")
            currency_from(:integer, "Transaction currency_from")
            amount_from(:double, "Transaction amount_from")
            currency_to(:integer, "Transaction currency_to")
            amount_to(:double, "Transaction amount_to")
            fee_convert(:double, "Transaction fee_convert")
            api_currency_id(:string, "Transaction api_currency_id")
            user_id(:integer, "Transaction user_id")
            inserted_at(:string, "Transaction inserted_at")
          end

          example(%{
            id: 123,
            currency_from: 1,
            amount_from: 120.5,
            currency_to: 1,
            amount_to: 120.5,
            fee_convert: 1,
            user_id: 2,
            api_currency_id: 1,
            inserted_at: "2022-05-01T23:22:20"
          })
        end,
      ConvertRequest:
        swagger_schema do
          title("ConvertRequest")
          description("POST body for creating a transaction")
          property(:transaction, Schema.ref(:Transaction), "The convert transaction details")

          example(%{
            transaction: %{
              currency_from: 1,
              amount_from: 120.5,
              currency_to: 1,
              api_currency_id: 1
            }
          })
        end,
      TransactionRequest:
        swagger_schema do
          title("TransactionRequest")
          description("POST body for creating a transaction")
          property(:transaction, Schema.ref(:Transaction), "The transaction details")

          example(%{
            transaction: %{
              currency_from: 1,
              amount_from: 120.5,
              currency_to: 1,
              amount_to: 120.5,
              fee_convert: 1,
              api_currency_id: 1
            }
          })
        end,
      TransactionResponse:
        swagger_schema do
          title("TransactionResponse")
          description("Response schema for single transaction")
          property(:data, Schema.ref(:Transaction), "The transaction details")
        end,
      TransactionsResponse:
        swagger_schema do
          title("TransactionResponse")
          description("Response schema for multiple transactions")
          property(:data, Schema.array(:Transaction), "The transactions details")
        end
    }
  end

  def index(conn, _params) do
    if Guardian.Plug.authenticated?(conn) do
      render(conn, "index.json",
        transactions: Transactions.list_transactions(Guardian.Plug.current_resource(conn)),
        user_id: Guardian.Plug.current_resource(conn).id
      )
    else
      render(conn, "index.html",
        transactions: Transactions.list_transactions(conn.assigns.current_user),
        currencies: Currencies.list_currencies()
      )
    end
  end

  def new(conn, _params) do
    changeset = Transactions.change_transaction(%Transaction{})
    currencies = Currencies.list_currencies()

    if Guardian.Plug.authenticated?(conn) do
      api_currencies = ApiCurrencies.list_api_currencies(Guardian.Plug.current_resource(conn))

      render(conn, "new.json",
        changeset: changeset,
        currencies: currencies,
        api_currencies: api_currencies,
        selected_currency_from: 0,
        selected_currency_to: 0,
        selected_api_currency: 0
      )
    else
      api_currencies = ApiCurrencies.list_api_currencies(conn.assigns.current_user)

      render(conn, "new.html",
        changeset: changeset,
        currencies: currencies,
        api_currencies: api_currencies,
        selected_currency_from: 0,
        selected_currency_to: 0,
        selected_api_currency: 0
      )
    end
  end

  def create(conn, %{"transaction" => transaction_params}) do
    if Guardian.Plug.authenticated?(conn) do
      transaction_params =
        Map.put(transaction_params, "user_id", Guardian.Plug.current_resource(conn).id)

      case Transactions.create_transaction(transaction_params) do
        {:ok, transaction} ->
          conn
          |> put_status(:created)
          |> render("show.json", transaction: transaction)

        {:error, %Ecto.Changeset{} = _changeset} ->
          conn
          |> put_status(400)
          |> render("error.json", message: "Transaction could not be created, malformed data")
      end
    else
      transaction_params = Map.put(transaction_params, "user_id", conn.assigns.current_user.id)

      case Transactions.create_transaction(transaction_params) do
        {:ok, transaction} ->
          conn
          |> put_flash(:info, "Transaction created successfully.")
          |> redirect(to: Routes.transaction_path(conn, :show, transaction))

        {:error, %Ecto.Changeset{} = changeset} ->
          api_currencies = ApiCurrencies.list_api_currencies(conn.assigns.current_user)
          currencies = Currencies.list_currencies()

          render(conn, "new.html",
            changeset: changeset,
            transaction: transaction_params,
            currencies: currencies,
            api_currencies: api_currencies,
            selected_currency_from: 0,
            selected_currency_to: 0,
            selected_api_currency: 0
          )
      end
    end
  end

  def show(conn, %{"id" => id}) do
    if Guardian.Plug.authenticated?(conn) do
      transaction = Transactions.get_transaction!(Guardian.Plug.current_resource(conn), id)
      api_currency = ApiCurrencies.get_api_currency_by_id!(transaction.api_currency_id)
      currency_from = Currencies.get_currency!(transaction.currency_from)
      currency_to = Currencies.get_currency!(transaction.currency_to)

      render(conn, "show.json",
        transaction: transaction,
        api_currency: api_currency,
        currency_from: currency_from,
        currency_to: currency_to
      )
    else
      transaction = Transactions.get_transaction!(conn.assigns.current_user, id)
      api_currency = ApiCurrencies.get_api_currency_by_id!(transaction.api_currency_id)
      currency_from = Currencies.get_currency!(transaction.currency_from)
      currency_to = Currencies.get_currency!(transaction.currency_to)

      render(conn, "show.html",
        transaction: transaction,
        api_currency: api_currency,
        currency_from: currency_from,
        currency_to: currency_to
      )
    end
  end

  def edit(conn, %{"id" => id}) do
    if Guardian.Plug.authenticated?(conn) do
      transaction = Transactions.get_transaction!(Guardian.Plug.current_resource(conn), id)
      changeset = Transactions.change_transaction(transaction)

      currencies = Currencies.list_currencies()
      api_currencies = ApiCurrencies.list_api_currencies(Guardian.Plug.current_resource(conn))

      render(conn, "edit.json",
        transaction: transaction,
        changeset: changeset,
        currencies: currencies,
        api_currencies: api_currencies,
        selected_currency_from: transaction.currency_from,
        selected_currency_to: transaction.currency_to,
        selected_api_currency: transaction.api_currency_id
      )
    else
      transaction = Transactions.get_transaction!(conn.assigns.current_user, id)
      changeset = Transactions.change_transaction(transaction)

      currencies = Currencies.list_currencies()
      api_currencies = ApiCurrencies.list_api_currencies(conn.assigns.current_user)

      render(conn, "edit.html",
        transaction: transaction,
        changeset: changeset,
        currencies: currencies,
        api_currencies: api_currencies,
        selected_currency_from: transaction.currency_from,
        selected_currency_to: transaction.currency_to,
        selected_api_currency: transaction.api_currency_id
      )
    end
  end

  def update(conn, %{"id" => id, "transaction" => transaction_params}) do
    if Guardian.Plug.authenticated?(conn) do
      transaction = Transactions.get_transaction!(Guardian.Plug.current_resource(conn), id)

      case Transactions.update_transaction(transaction, transaction_params) do
        {:ok, transaction} ->
          conn
          |> put_status(200)
          |> redirect(to: Routes.transaction_path(conn, :show, transaction))

        {:error, %Ecto.Changeset{} = _changeset} ->
          conn
          |> put_status(400)
          |> render("error.json", message: "Transaction could not be updated. Invalid data type.")
      end
    else
      transaction = Transactions.get_transaction!(conn.assigns.current_user, id)

      case Transactions.update_transaction(transaction, transaction_params) do
        {:ok, transaction} ->
          conn
          |> put_flash(:info, "Transaction updated successfully.")
          |> redirect(to: Routes.transaction_path(conn, :show, transaction))

        {:error, %Ecto.Changeset{} = changeset} ->
          currencies = Currencies.list_currencies()
          api_currencies = ApiCurrencies.list_api_currencies(conn.assigns.current_user)

          render(conn, "edit.html",
            transaction: transaction,
            changeset: changeset,
            currencies: currencies,
            api_currencies: api_currencies,
            selected_currency_from: transaction.currency_from,
            selected_currency_to: transaction.currency_to,
            selected_api_currency: transaction.api_currency_id
          )
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    if Guardian.Plug.authenticated?(conn) do
      transaction = Transactions.get_transaction!(Guardian.Plug.current_resource(conn), id)
      {:ok, _transaction} = Transactions.delete_transaction(transaction)

      conn
      |> put_status(200)
      |> redirect(to: Routes.transaction_path(conn, :index))
    else
      transaction = Transactions.get_transaction!(conn.assigns.current_user, id)
      {:ok, _transaction} = Transactions.delete_transaction(transaction)

      conn
      |> put_flash(:info, "Transaction deleted successfully.")
      |> redirect(to: Routes.transaction_path(conn, :index))
    end
  end

  def convert(conn, %{"transaction" => transaction_params}) do
    api_currency = ApiCurrencies.get_api_currency_by_id!(transaction_params["api_currency_id"])
    currency_from = Currencies.get_currency!(transaction_params["currency_from"])
    currency_to = Currencies.get_currency!(transaction_params["currency_to"])
    # convert amount / TODO: change block to case statement
    result =
      CurrencyConverter.process(
        api_currency.url,
        api_currency.api_key,
        transaction_params["amount_from"],
        currency_from.name,
        currency_to.name
      )

    # set amount converted and fee/quote used in process.
    transaction_params = Map.put(transaction_params, "amount_to", result[:result])
    transaction_params = Map.put(transaction_params, "fee_convert", result[:info]["quote"])
    # update api_currency service utilized to perform
    ApiCurrencies.decrease_remaining_conversions(api_currency)

    if Guardian.Plug.authenticated?(conn) do
      transaction_params =
        Map.put(transaction_params, "user_id", Guardian.Plug.current_resource(conn).id)

      case Transactions.create_transaction(transaction_params) do
        {:ok, transaction} ->
          conn
          |> put_status(:created)
          |> render("show.json", transaction: transaction)

        {:error, %Ecto.Changeset{} = _changeset} ->
          conn
          |> put_status(400)
          |> render("error.json", message: "Transaction could not be created, malformed data")
      end
    else
      # Only JWT users can use convert \ TODO: create a view to allow browser convert
    end
  end
end
