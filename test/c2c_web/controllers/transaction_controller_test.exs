defmodule C2cWeb.TransactionControllerTest do
  use C2cWeb.ConnCase, async: true

  import C2c.TransactionsFixtures
  alias C2c.Accounts
  alias C2cWeb.UserAuth

  setup %{conn: conn} do
    user = C2c.AccountsFixtures.user_fixture()

    conn =
      conn
      |> Map.replace!(:secret_key_base, C2cWeb.Endpoint.config(:secret_key_base))
      |> init_test_session(%{})

    user_token = Accounts.generate_user_session_token(user)
    conn = conn |> put_session(:user_token, user_token) |> UserAuth.fetch_current_user([])

    # create data
    currency_from = C2c.CurrenciesFixtures.currency_fixture()
    currency_to = C2c.CurrenciesFixtures.currency_fixture()
    api_currency = C2c.ApiCurrenciesFixtures.api_currency_fixture(conn.assigns.current_user.id)

    transaction =
      transaction_fixture(
        conn.assigns.current_user.id,
        currency_from.id,
        currency_to.id,
        api_currency.id
      )

    currencies = C2c.CurrenciesFixtures.list_currency_fixture()

    api_currencies =
      C2c.ApiCurrenciesFixtures.list_api_currencies_fixture(conn.assigns.current_user)

    create_attrs = %{
      currency_from: currency_from.id,
      currency_to: currency_to.id,
      api_currency_id: api_currency.id,
      amount_from: 1,
      amount_to: 12,
      fee_convert: 12,
      user_id: conn.assigns.current_user.id
    }

    invalid_attrs = %{
      currency_from: nil,
      currency_to: nil,
      api_currency_id: nil,
      amount_from: nil,
      amount_to: nil,
      fee_convert: nil,
      user_id: conn.assigns.current_user.id
    }

    %{
      conn: conn,
      transaction: transaction,
      currencies: currencies,
      api_currencies: api_currencies,
      create_attrs: create_attrs,
      invalid_attrs: invalid_attrs
    }
  end

  @update_attrs %{amount_from: 456.7, amount_to: 456.7, fee_convert: 456.7}

  describe "index" do
    test "lists all transactions", %{conn: conn} do
      conn = get(conn, Routes.transaction_path(conn, :index))
      assert html_response(conn, 200) =~ "Transactions"
    end
  end

  describe "new transaction" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.transaction_path(conn, :new))
      assert html_response(conn, 200) =~ "New Transaction"
    end
  end

  describe "create transaction" do
    test "redirects to show when data is valid", %{conn: conn, create_attrs: create_attrs} do
      conn = post(conn, Routes.transaction_path(conn, :create), transaction: create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.transaction_path(conn, :show, id)

      conn = get(conn, Routes.transaction_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Transaction"
    end

    test "renders errors when data is invalid", %{conn: conn, invalid_attrs: invalid_attrs} do
      conn = post(conn, Routes.transaction_path(conn, :create), transaction: invalid_attrs)
      assert html_response(conn, 200) =~ "New Transaction"
    end
  end

  describe "edit transaction" do
    test "renders form for editing chosen transaction", %{conn: conn, transaction: transaction} do
      conn = get(conn, Routes.transaction_path(conn, :edit, transaction))
      assert html_response(conn, 200) =~ "Edit Transaction"
    end
  end

  describe "update transaction" do
    test "redirects when data is valid", %{conn: conn, transaction: transaction} do
      conn =
        put(conn, Routes.transaction_path(conn, :update, transaction), transaction: @update_attrs)

      assert redirected_to(conn) == Routes.transaction_path(conn, :show, transaction)

      conn = get(conn, Routes.transaction_path(conn, :show, transaction))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      transaction: transaction,
      invalid_attrs: invalid_attrs
    } do
      conn =
        put(conn, Routes.transaction_path(conn, :update, transaction), transaction: invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Transaction"
    end
  end

  describe "delete transaction" do
    test "deletes chosen transaction", %{conn: conn, transaction: transaction} do
      conn = delete(conn, Routes.transaction_path(conn, :delete, transaction))
      assert redirected_to(conn) == Routes.transaction_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, Routes.transaction_path(conn, :show, transaction))
      end)
    end
  end
end
