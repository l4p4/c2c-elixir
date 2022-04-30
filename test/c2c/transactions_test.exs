defmodule C2c.TransactionsTest do
  use C2c.DataCase

  alias C2c.Transactions

  setup do
    user = C2c.AccountsFixtures.user_fixture()

    %{
      user: user,
      currency_from: C2c.CurrenciesFixtures.currency_fixture(),
      currency_to: C2c.CurrenciesFixtures.currency_fixture(),
      api_currency: C2c.ApiCurrenciesFixtures.api_currency_fixture(user.id)
    }
  end

  describe "transactions" do
    alias C2c.Transactions.Transaction

    import C2c.TransactionsFixtures

    @invalid_attrs %{amount_from: nil, amount_to: nil, fee_convert: nil}

    test "list_transactions/0 returns all transactions", %{
      user: user,
      currency_from: currency_from,
      currency_to: currency_to,
      api_currency: api_currency
    } do
      transaction =
        transaction_fixture(user.id, currency_from.id, currency_to.id, api_currency.id)

      assert Transactions.list_transactions(user) == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id", %{
      user: user,
      currency_from: currency_from,
      currency_to: currency_to,
      api_currency: api_currency
    } do
      transaction =
        transaction_fixture(user.id, currency_from.id, currency_to.id, api_currency.id)

      assert Transactions.get_transaction!(user, transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction", %{
      user: user,
      currency_from: currency_from,
      currency_to: currency_to,
      api_currency: api_currency
    } do
      valid_attrs = %{
        amount_from: 120.5,
        amount_to: 120.5,
        fee_convert: 120.5,
        currency_from: currency_from.id,
        currency_to: currency_to.id,
        api_currency_id: api_currency.id,
        user_id: user.id
      }

      assert {:ok, %Transaction{} = transaction} = Transactions.create_transaction(valid_attrs)
      assert transaction.amount_from == 120.5
      assert transaction.amount_to == 120.5
      assert transaction.fee_convert == 120.5
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction", %{
      user: user,
      currency_from: currency_from,
      currency_to: currency_to,
      api_currency: api_currency
    } do
      transaction =
        transaction_fixture(user.id, currency_from.id, currency_to.id, api_currency.id)

      update_attrs = %{amount_from: 456.7, amount_to: 456.7, fee_convert: 456.7}

      assert {:ok, %Transaction{} = transaction} =
               Transactions.update_transaction(transaction, update_attrs)

      assert transaction.amount_from == 456.7
      assert transaction.amount_to == 456.7
      assert transaction.fee_convert == 456.7
    end

    test "update_transaction/2 with invalid data returns error changeset", %{
      user: user,
      currency_from: currency_from,
      currency_to: currency_to,
      api_currency: api_currency
    } do
      transaction =
        transaction_fixture(user.id, currency_from.id, currency_to.id, api_currency.id)

      assert {:error, %Ecto.Changeset{}} =
               Transactions.update_transaction(transaction, @invalid_attrs)

      assert transaction == Transactions.get_transaction!(user, transaction.id)
    end

    test "delete_transaction/1 deletes the transaction", %{
      user: user,
      currency_from: currency_from,
      currency_to: currency_to,
      api_currency: api_currency
    } do
      transaction =
        transaction_fixture(user.id, currency_from.id, currency_to.id, api_currency.id)

      assert {:ok, %Transaction{}} = Transactions.delete_transaction(transaction)

      assert_raise Ecto.NoResultsError, fn ->
        Transactions.get_transaction!(user, transaction.id)
      end
    end

    test "change_transaction/1 returns a transaction changeset", %{
      user: user,
      currency_from: currency_from,
      currency_to: currency_to,
      api_currency: api_currency
    } do
      transaction =
        transaction_fixture(user.id, currency_from.id, currency_to.id, api_currency.id)

      assert %Ecto.Changeset{} = Transactions.change_transaction(transaction)
    end
  end
end
