defmodule C2c.ApiCurrencies.ApiCurrency do
  use Ecto.Schema
  import Ecto.Changeset

  schema "api_currencies" do
    field :api_key, :string
    field :description, :string
    field :limit, :integer
    field :remaining_conversions, :integer
    field :url, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(api_currency, attrs) do
    api_currency
    |> cast(attrs, [:url, :api_key, :limit, :remaining_conversions, :description, :user_id])
    |> validate_required([:url, :api_key, :limit, :remaining_conversions, :description, :user_id])
  end
end
