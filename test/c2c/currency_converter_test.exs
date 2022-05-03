defmodule C2c.CurrencyConverterTest do
  use C2cWeb.ConnCase

  alias C2c.CurrencyConverter

  setup do
    %{
      url: "https://api.api/cd/convert?to=:to&from=:from&amount=:amount",
      url_changed: "https://api.api/cd/convert?to=USD&from=BRL&amount=10",
      invalid_url: "https://api.api/cd/convert?to=:to&from=:from&amount=:cash",
      from: "BRL",
      to: "USD",
      amount: 10
    }
  end

  describe "currency converter binds" do
    test "verify valid binds", %{
      url: url,
      from: from,
      to: to,
      amount: amount,
      url_changed: url_changed
    } do
      assert CurrencyConverter.bind(url, from, to, amount) == url_changed
    end

    test "verify invalid url", %{
      url: url,
      from: from,
      to: to,
      amount: amount,
      invalid_url: invalid_url
    } do
      assert CurrencyConverter.bind(url, from, to, amount) != invalid_url
    end
  end
end
