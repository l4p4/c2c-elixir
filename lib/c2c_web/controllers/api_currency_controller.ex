defmodule C2cWeb.ApiCurrencyController do
  use C2cWeb, :controller

  alias C2c.ApiCurrencies
  alias C2c.ApiCurrencies.ApiCurrency

  def index(conn, _params) do
    api_currencies = ApiCurrencies.list_api_currencies(conn.assigns.current_user)
    render(conn, "index.html", api_currencies: api_currencies)
  end

  def new(conn, _params) do
    changeset = ApiCurrencies.change_api_currency(%ApiCurrency{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"api_currency" => api_currency_params}) do
    api_currency_params = Map.put(api_currency_params, "user_id", conn.assigns.current_user.id)

    case ApiCurrencies.create_api_currency(api_currency_params) do
      {:ok, api_currency} ->
        conn
        |> put_flash(:info, "Api currency created successfully.")
        |> redirect(to: Routes.api_currency_path(conn, :show, api_currency))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    api_currency = ApiCurrencies.get_api_currency!(conn.assigns.current_user, id)
    render(conn, "show.html", api_currency: api_currency)
  end

  def edit(conn, %{"id" => id}) do
    api_currency = ApiCurrencies.get_api_currency!(conn.assigns.current_user, id)
    changeset = ApiCurrencies.change_api_currency(api_currency)
    render(conn, "edit.html", api_currency: api_currency, changeset: changeset)
  end

  def update(conn, %{"id" => id, "api_currency" => api_currency_params}) do
    api_currency = ApiCurrencies.get_api_currency!(conn.assigns.current_user, id)

    case ApiCurrencies.update_api_currency(api_currency, api_currency_params) do
      {:ok, api_currency} ->
        conn
        |> put_flash(:info, "Api currency updated successfully.")
        |> redirect(to: Routes.api_currency_path(conn, :show, api_currency))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", api_currency: api_currency, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    api_currency = ApiCurrencies.get_api_currency!(conn.assigns.current_user, id)
    {:ok, _api_currency} = ApiCurrencies.delete_api_currency(api_currency)

    conn
    |> put_flash(:info, "Api currency deleted successfully.")
    |> redirect(to: Routes.api_currency_path(conn, :index))
  end
end
