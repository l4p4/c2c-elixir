defmodule C2cWeb.TransactionController do
  use C2cWeb, :controller

  alias C2c.ApiCurrencies
  alias C2c.Currencies
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
            id: 1,
            amount_from: 120.5,
            amount_to: 120.5,
            fee_convert: 120.5
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
        transaction: %{amount_from: 120.5, amount_to: 120.5, fee_convert: 120.5}
      }
    )

    response(201, "Transaction created OK", Schema.ref(:TransactionResponse),
      example: %{
        data: %{
          id: 1,
          amount_from: 120.5,
          amount_to: 120.5,
          fee_convert: 120.5
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
          amount_from: 120.5,
          amount_to: 120.5,
          fee_convert: 120.5
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
          transaction: %{amount_from: 120.5, amount_to: 120.5, fee_convert: 120.5}
        }
      )
    end

    response(200, "Updated Successfully", Schema.ref(:TransactionResponse),
      example: %{
        data: %{
          id: 3,
          amount_from: 120.5,
          amount_to: 120.5,
          fee_convert: 120.5
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

  def swagger_definitions do
    %{
      Transaction:
        swagger_schema do
          title("Transaction")
          description("A transaction of the app")

          properties do
            id(:integer, "Transaction ID")
            amount_from(:string, "Transaction amount_from")
            amount_to(:string, "Transaction amount_to")
            fee_convert(:string, "Transaction fee_convert")
          end

          example(%{
            id: 123,
            amount_from: 120.5,
            amount_to: 120.5,
            fee_convert: 120.5
          })
        end,
      TransactionRequest:
        swagger_schema do
          title("TransactionRequest")
          description("POST body for creating a transaction")
          property(:transaction, Schema.ref(:Transaction), "The transaction details")

          example(%{
            transaction: %{
              amount_from: 120.5,
              amount_to: 120.5,
              fee_convert: 120.5
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
require Logger
  def index(conn, _params) do
    transactions = Transactions.list_transactions(conn.assigns.current_user)
    currencies = Currencies.list_currencies()

    render(conn, :index, transactions: transactions, currencies: currencies)
  end

  def new(conn, _params) do
    changeset = Transactions.change_transaction(%Transaction{})
    currencies = Currencies.list_currencies()
    api_currencies = ApiCurrencies.list_api_currencies(conn.assigns.current_user)

    render(conn, :new,
      changeset: changeset,
      currencies: currencies,
      api_currencies: api_currencies,
      selected_currency_from: 0,
      selected_currency_to: 0,
      selected_api_currency: 0
    )
  end

  def create(conn, %{"transaction" => transaction_params}) do
    transaction_params = Map.put(transaction_params, "user_id", conn.assigns.current_user.id)

    case Transactions.create_transaction(transaction_params) do
      {:ok, transaction} ->
        conn
        |> put_flash(:info, "Transaction created successfully.")
        |> redirect(to: Routes.transaction_path(conn, :show, transaction))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    transaction = Transactions.get_transaction!(conn.assigns.current_user, id)
    api_currency = ApiCurrencies.get_api_currency_by_id!(transaction.api_currency_id)
    currency_from = Currencies.get_currency!(transaction.currency_from)
    currency_to = Currencies.get_currency!(transaction.currency_to)

    render(conn, :show,
      transaction: transaction,
      api_currency: api_currency,
      currency_from: currency_from,
      currency_to: currency_to
    )
  end

  def edit(conn, %{"id" => id}) do
    transaction = Transactions.get_transaction!(conn.assigns.current_user, id)
    changeset = Transactions.change_transaction(transaction)

    currencies = Currencies.list_currencies()
    api_currencies = ApiCurrencies.list_api_currencies(conn.assigns.current_user)

    render(conn, :edit,
      transaction: transaction,
      changeset: changeset,
      currencies: currencies,
      api_currencies: api_currencies,
      selected_currency_from: transaction.currency_from,
      selected_currency_to: transaction.currency_to,
      selected_api_currency: transaction.api_currency_id
    )
  end

  def update(conn, %{"id" => id, "transaction" => transaction_params}) do
    transaction = Transactions.get_transaction!(conn.assigns.current_user, id)

    case Transactions.update_transaction(transaction, transaction_params) do
      {:ok, transaction} ->
        conn
        |> put_flash(:info, "Transaction updated successfully.")
        |> redirect(to: Routes.transaction_path(conn, :show, transaction))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, transaction: transaction, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    transaction = Transactions.get_transaction!(conn.assigns.current_user, id)
    {:ok, _transaction} = Transactions.delete_transaction(transaction)

    conn
    |> put_flash(:info, "Transaction deleted successfully.")
    |> redirect(to: Routes.transaction_path(conn, :index))
  end
end
