defmodule C2c.Transactions.Transaction do
  @moduledoc """
  The Transaction module.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field(:amount_from, :float)
    field(:amount_to, :float)
    field(:fee_convert, :float)
    field(:user_id, :id)
    field(:currency_from, :id)
    field(:currency_to, :id)
    field(:api_currency_id, :id)

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [
      :amount_from,
      :amount_to,
      :fee_convert,
      :user_id,
      :currency_from,
      :currency_to,
      :api_currency_id
    ])
    |> validate_required([
      :amount_from,
      :amount_to,
      :fee_convert,
      :user_id,
      :currency_from,
      :currency_to,
      :api_currency_id
    ])
  end
end
