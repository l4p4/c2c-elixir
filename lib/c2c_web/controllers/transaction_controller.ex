defmodule C2cWeb.TransactionController do
  use C2cWeb, :controller

  alias C2c.ApiCurrencies
  alias C2c.Currencies
  alias C2c.Transactions
  alias C2c.Transactions.Transaction

  def index(conn, _params) do
    transactions = Transactions.list_transactions(conn.assigns.current_user)
    render(conn, "index.html", transactions: transactions)
  end

  def new(conn, _params) do
    changeset = Transactions.change_transaction(%Transaction{})
    currencies = Currencies.list_currencies()
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

  def create(conn, %{"transaction" => transaction_params}) do
    transaction_params = Map.put(transaction_params, "user_id", conn.assigns.current_user.id)

    case Transactions.create_transaction(transaction_params) do
      {:ok, transaction} ->
        conn
        |> put_flash(:info, "Transaction created successfully.")
        |> redirect(to: Routes.transaction_path(conn, :show, transaction))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
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

  def edit(conn, %{"id" => id}) do
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

  def update(conn, %{"id" => id, "transaction" => transaction_params}) do
    transaction = Transactions.get_transaction!(conn.assigns.current_user, id)

    case Transactions.update_transaction(transaction, transaction_params) do
      {:ok, transaction} ->
        conn
        |> put_flash(:info, "Transaction updated successfully.")
        |> redirect(to: Routes.transaction_path(conn, :show, transaction))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", transaction: transaction, changeset: changeset)
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
