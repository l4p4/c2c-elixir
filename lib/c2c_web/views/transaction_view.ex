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
      amount_from: transaction.amount_from,
      amount_to: transaction.amount_to,
      fee_convert: transaction.fee_convert
    }
  end
end
