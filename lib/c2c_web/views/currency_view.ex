defmodule C2cWeb.CurrencyView do
  use C2cWeb, :view

  def render("index.json", %{currencies: currencies}), do: currencies
  def render("show.json", %{currency: currency}), do: currency
end
