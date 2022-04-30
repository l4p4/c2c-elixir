defmodule C2c.TransactionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `C2c.Transactions` context.
  """

  @doc """
  Generate a transaction.
  """
  def transaction_fixture(
        user_id,
        currency_from_id,
        currency_to_id,
        api_currency_id,
        attrs \\ %{}
      ) do
    {:ok, transaction} =
      attrs
      |> Enum.into(%{
        currency_from: currency_from_id,
        currency_to: currency_to_id,
        api_currency_id: api_currency_id,
        amount_from: 120.5,
        amount_to: 120.5,
        fee_convert: 1,
        user_id: user_id
      })
      |> C2c.Transactions.create_transaction()

    transaction
  end
end
