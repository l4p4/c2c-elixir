# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     C2c.Repo.insert!(%C2c.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias C2c.Repo
alias C2c.Currencies.Currency

Repo.insert! %Currency{
  name: "USD"
}

Repo.insert! %Currency{
  name: "JPY"
}

Repo.insert! %Currency{
  name: "EUR"
}

Repo.insert! %Currency{
  name: "BRL"
}