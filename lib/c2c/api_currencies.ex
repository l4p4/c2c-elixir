defmodule C2c.ApiCurrencies do
  @moduledoc """
  The ApiCurrencies context.
  """

  import Ecto.Query, warn: false
  alias C2c.Repo

  alias C2c.ApiCurrencies.ApiCurrency

  @doc """
  Returns the list of api_currencies.

  ## Examples

      iex> list_api_currencies()
      [%ApiCurrency{}, ...]

  """
  def list_api_currencies(user) do
    Repo.all(filter_currencies_by_user_id(user))
  end

  @doc """
  Gets a single api_currency.

  Raises `Ecto.NoResultsError` if the Api currency does not exist.

  ## Examples

      iex> get_api_currency!(123)
      %ApiCurrency{}

      iex> get_api_currency!(456)
      ** (Ecto.NoResultsError)

  """
  def get_api_currency!(user, id), do: Repo.get!(filter_currencies_by_user_id(user), id)

  @doc """
  """
  def get_api_currency_by_id!(id), do: Repo.get!(ApiCurrency, id)

  # Filter registers by user to show only specific data, created by user in assoc.
  defp filter_currencies_by_user_id(user) do
    Ecto.assoc(user, :api_currencies)
  end

  @doc """
  Creates a api_currency.

  ## Examples

      iex> create_api_currency(%{field: value})
      {:ok, %ApiCurrency{}}

      iex> create_api_currency(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_api_currency(attrs) do
    %ApiCurrency{}
    |> ApiCurrency.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a api_currency.

  ## Examples

      iex> update_api_currency(api_currency, %{field: new_value})
      {:ok, %ApiCurrency{}}

      iex> update_api_currency(api_currency, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_api_currency(%ApiCurrency{} = api_currency, attrs) do
    api_currency
    |> ApiCurrency.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a api_currency.

  ## Examples

      iex> delete_api_currency(api_currency)
      {:ok, %ApiCurrency{}}

      iex> delete_api_currency(api_currency)
      {:error, %Ecto.Changeset{}}

  """
  def delete_api_currency(%ApiCurrency{} = api_currency) do
    Repo.delete(api_currency)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking api_currency changes.

  ## Examples

      iex> change_api_currency(api_currency)
      %Ecto.Changeset{data: %ApiCurrency{}}

  """
  def change_api_currency(%ApiCurrency{} = api_currency, attrs \\ %{}) do
    ApiCurrency.changeset(api_currency, attrs)
  end
end
