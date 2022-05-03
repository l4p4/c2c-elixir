defmodule C2c.CurrencyConverter do
  @moduledoc """
  The Currency Converter module.
  """
  require HTTPoison

  @expected_fields ~w(success query info result quote)

  # Access a given service to convert and return amount in a new currency
  def process(url, api_key, amount, currency_from, currency_to) do
    url = bind(url, currency_from, currency_to, amount)
    headers = [apikey: api_key]

    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Jason.decode!()
        |> Map.take(@expected_fields)
        |> Enum.map(fn {k, v} -> {String.to_atom(k), v} end)

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts("Not found :(")

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end

  # Replace bind by data
  def bind(url, from, to, amount) do
    if valid_uri?(url) && valid_binds?(url) do
      url
      |> String.replace(":from", from)
      |> String.replace(":to", to)
      |> String.replace(":amount", "#{amount}")
    end
  end

  # Reject domains without a scheme and a dot
  defp valid_uri?(url) do
    uri = URI.parse(url)
    uri.scheme != nil && uri.host =~ "."
  end

  # Reject domains without correct binds :from, :to, :amount
  defp valid_binds?(url) do
    uri = URI.parse(url)
    uri.query =~ ":from" && uri.query =~ ":to" && uri.query =~ ":amount"
  end
end