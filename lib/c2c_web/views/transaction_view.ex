defmodule C2cWeb.TransactionView do
  use C2cWeb, :view
  alias C2cWeb.TransactionView

  def render("index.json", %{transactions: transactions}) do
    %{data: render_many(transactions, TransactionView, "transaction.json")}
  end

  def render("show.json", %{transaction: transaction}) do
    %{data: render_one(transaction, TransactionView, "transaction.json")}
  end

  def render("transaction.json", %{transaction: transaction}) do
    %{
      id: transaction.id,
      user_id: transaction.user_id,
      currency_from: transaction.currency_from,
      amount_from: transaction.amount_from,
      currency_to: transaction.currency_to,
      amount_to: transaction.amount_to,
      fee_convert: transaction.fee_convert,
      api_currency_id: transaction.api_currency_id,
      inserted_at: transaction.inserted_at
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
