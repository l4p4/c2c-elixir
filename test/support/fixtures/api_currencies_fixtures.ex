defmodule C2c.ApiCurrenciesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `C2c.ApiCurrencies` context.
  """

  @doc """
  Generate a api_currency.
  """
  def api_currency_fixture(attrs \\ %{}) do
    {:ok, api_currency} =
      attrs
      |> Enum.into(%{
        api_key: "some api_key",
        description: "some description",
        limit: 42,
        remaining_conversions: 42,
        url: "some url"
      })
      |> C2c.ApiCurrencies.create_api_currency()

    api_currency
  end
end
