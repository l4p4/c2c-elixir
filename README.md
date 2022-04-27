# C2C 

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
Run in another port with:  `PORT=8080 mix phx.server`

<hr />

####[Running tests with ExUnit](https://hexdocs.pm/ex_unit/ExUnit.html)
######ExUnit - Unit testing framework for Elixir.
`mix test --color`

#####[Verifying Lint with Credo](https://github.com/rrrene/credo)
######Credo is a static code analysis tool for the Elixir language with a focus on teaching and code consistency.
`mix credo --strict`

#####[Documentation](https://github.com/akoutmos/doctor)
######Ensure that your documentation is healthy with Doctor! This library contains a mix task that you can run against your project to generate a documentation coverage report.
`mix doctor --summary`

#####[Using Dialyzer in Elixir](https://github.com/jeremyjh/dialyxir)
######The Dialyzer, a DIscrepancy AnalYZer for ERlang programs. Dialyzer is a static analysis tool used for checking types and other discrepancies such as dead or unreachable code. Dialyzer examines .erl or .beam files (not .ex or .exs) – more on this in a minute.
`mix dialyzer`

####[Git Hook](https://github.com/qgadrian/elixir_git_hooks)
###### Simplicity: Automatic or manually install the configured git hook actions.
```
pre_commit: [
tasks: [
        {:cmd, "mix clean"},
        {:cmd, "mix compile --warnings-as-errors"},
        {:cmd, "mix format --check-formatted"},
        {:cmd, "mix credo --strict"},
        {:cmd, "mix doctor --summary"},
        {:cmd, "mix test"}
    ]
],
pre_push: [
        verbose: false,
        tasks: [
            {:cmd, "mix dialyzer"},
            {:cmd, "mix test --color"},
            {:cmd, "echo 'success!'"}
        ]
] 
```

#####[SEED DataBase](https://hexdocs.pm/phoenix/1.3.0-rc.0/seeding_data.html)
######Run the follow command to populate currency table.
`mix run priv/repo/seeds.exs`

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
