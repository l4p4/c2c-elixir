defmodule C2c.Repo.Migrations.CreateApiCurrencies do
  use Ecto.Migration

  def change do
    create table(:api_currencies) do
      add :url, :string
      add :api_key, :string
      add :limit, :integer
      add :remaining_conversions, :integer
      add :description, :text
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:api_currencies, [:user_id])
  end
end
