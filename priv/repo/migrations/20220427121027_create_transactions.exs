defmodule C2c.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :amount_from, :float
      add :amount_to, :float
      add :fee_convert, :float
      add :user_id, references(:users, on_delete: :nothing)
      add :currency_from, references(:currencies, on_delete: :nothing)
      add :currency_to, references(:currencies, on_delete: :nothing)
      add :api_currency_id, references(:api_currencies, on_delete: :nothing)

      timestamps()
    end

    create index(:transactions, [:user_id])
    create index(:transactions, [:currency_from])
    create index(:transactions, [:currency_to])
    create index(:transactions, [:api_currency_id])
  end
end
