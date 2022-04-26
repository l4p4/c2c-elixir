defmodule C2c.CurrenciesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `C2c.Currencies` context.
  """

  @doc """
  Generate a currency.
  """
  def currency_fixture(attrs \\ %{}) do
    {:ok, currency} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> C2c.Currencies.create_currency()

    currency
  end
end
