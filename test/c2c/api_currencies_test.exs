defmodule C2c.ApiCurrenciesTest do
  use C2c.DataCase

  alias C2c.ApiCurrencies

  setup do
    %{user: C2c.AccountsFixtures.user_fixture()}
  end

  describe "api_currencies" do
    alias C2c.ApiCurrencies.ApiCurrency

    import C2c.ApiCurrenciesFixtures

    @invalid_attrs %{
      api_key: nil,
      description: nil,
      limit: nil,
      remaining_conversions: nil,
      url: nil
    }

    test "list_api_currencies/1 returns all api_currencies", %{user: user} do
      api_currency = api_currency_fixture(user.id)
      assert ApiCurrencies.list_api_currencies(user) == [api_currency]
    end

    test "get_api_currency!/2 returns the api_currency with given id", %{user: user} do
      api_currency = api_currency_fixture(user.id)
      assert ApiCurrencies.get_api_currency!(user, api_currency.id) == api_currency
    end

    test "create_api_currency/1 with valid data creates a api_currency", %{user: user} do
      valid_attrs = %{
        api_key: "some api_key",
        description: "some description",
        limit: 42,
        remaining_conversions: 42,
        url: "some url",
        user_id: user.id
      }

      assert {:ok, %ApiCurrency{} = api_currency} = ApiCurrencies.create_api_currency(valid_attrs)
      assert api_currency.api_key == "some api_key"
      assert api_currency.description == "some description"
      assert api_currency.limit == 42
      assert api_currency.remaining_conversions == 42
      assert api_currency.url == "some url"
    end

    test "create_api_currency/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ApiCurrencies.create_api_currency(@invalid_attrs)
    end

    test "update_api_currency/2 with valid data updates the api_currency", %{user: user} do
      api_currency = api_currency_fixture(user.id)

      update_attrs = %{
        api_key: "some updated api_key",
        description: "some updated description",
        limit: 43,
        remaining_conversions: 43,
        url: "some updated url"
      }

      assert {:ok, %ApiCurrency{} = api_currency} =
               ApiCurrencies.update_api_currency(api_currency, update_attrs)

      assert api_currency.api_key == "some updated api_key"
      assert api_currency.description == "some updated description"
      assert api_currency.limit == 43
      assert api_currency.remaining_conversions == 43
      assert api_currency.url == "some updated url"
    end

    test "update_api_currency/2 with invalid data returns error changeset", %{user: user} do
      api_currency = api_currency_fixture(user.id)

      assert {:error, %Ecto.Changeset{}} =
               ApiCurrencies.update_api_currency(api_currency, @invalid_attrs)

      assert api_currency == ApiCurrencies.get_api_currency!(user, api_currency.id)
    end

    test "delete_api_currency/1 deletes the api_currency", %{user: user} do
      api_currency = api_currency_fixture(user.id)
      assert {:ok, %ApiCurrency{}} = ApiCurrencies.delete_api_currency(api_currency)

      assert_raise Ecto.NoResultsError, fn ->
        ApiCurrencies.get_api_currency!(user, api_currency.id)
      end
    end

    test "change_api_currency/1 returns a api_currency changeset", %{user: user} do
      api_currency = api_currency_fixture(user.id)
      assert %Ecto.Changeset{} = ApiCurrencies.change_api_currency(api_currency)
    end
  end
end
