defmodule C2c.ApiCurrencies.ApiCurrency do
  @moduledoc """
    The API Currency module.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias C2c.Transactions.Transaction

  schema "api_currencies" do
    field(:api_key, :string)
    field(:description, :string)
    field(:limit, :integer)
    field(:remaining_conversions, :integer)
    field(:url, :string)
    field(:user_id, :id)
    has_many(:transactions, Transaction)

    timestamps()
  end

  @doc false
  def changeset(api_currency, attrs) do
    api_currency
    |> cast(attrs, [:url, :api_key, :limit, :remaining_conversions, :description, :user_id])
    |> validate_required([:url, :api_key, :limit, :user_id])
  end
end
