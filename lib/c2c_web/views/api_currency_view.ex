defmodule C2cWeb.ApiCurrencyView do
  use C2cWeb, :view
  alias C2cWeb.ApiCurrencyView

  def render("index.json", %{api_currencies: api_currencies}) do
    %{data: render_many(api_currencies, ApiCurrencyView, "api_currency.json")}
  end

  def render("show.json", %{api_currency: api_currency}) do
    %{data: render_one(api_currency, ApiCurrencyView, "api_currency.json")}
  end

  def render("api_currency.json", %{api_currency: api_currency}) do
    %{
      id: api_currency.id,
      url: api_currency.url,
      api_key: api_currency.api_key,
      limit: api_currency.limit,
      remaining_conversions: api_currency.remaining_conversions,
      description: api_currency.description,
      user_id: api_currency.user_id
    }
  end

  def render("error.json", %{message: message}) do
    %{
      status: :not_found,
      data: %{},
      message: message
    }
  end
end
