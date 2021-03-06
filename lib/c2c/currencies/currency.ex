defmodule C2c.Currencies.Currency do
  @moduledoc """
  The Currency module.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "currencies" do
    field(:name, :string)

    timestamps()
  end

  @doc false
  def changeset(currency, attrs) do
    currency
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
