defmodule C2c.TransactionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `C2c.Transactions` context.
  """

  @doc """
  Generate a transaction.
  """
  def transaction_fixture(attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(%{
        amount_from: 120.5,
        amount_to: 120.5,
        fee_convert: 120.5
      })
      |> C2c.Transactions.create_transaction()

    transaction
  end
end
