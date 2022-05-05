# C2C 
## _Its currency convert API/Platform_

C2C is a platform where users can register various APIs to perform currency conversions. Each user has a login, with their own APIs, not shared.

You can access your data from the API provided with swagger documentation in `/api/swagger`, using bearer token authentication.

It is also possible to access the platform after logging in.

## Features
- As a user you can register currencies, APIs and manager it.
- As a developer you can provider new controller and create easy swagger schema using `mix swagger.gen` task.
>for details check `lib/mix/taks`, for edit template scheme `priv/templates/swagger.gen`
- As a developer you can perform easy env. setup using vagrant with shared script in this project.
- As a developer you can deploy easy to heroku.

## To start your Phoenix server:

- Use vagrant file to configure all env with elixir/postgres/utilities
- Change `config/dev.exs` with yours database variables
- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Run the follow command to populate currency table `mix run priv/repo/seeds.exs`
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
Run in another port with:  `PORT=8080 mix phx.server`

Check Swagger API: [`localhost:4000/api/swagger`](http://localhost:4000/api/swagger)

<hr />

# Tech

[Phoenix Framework](https://phoenixframework.org/)
- Peace of mind from prototype to production.
Build rich, interactive web applications quickly, with less code and fewer moving parts. Join our growing community of developers using Phoenix to craft APIs, HTML5 apps and more, for fun or at scale.

[Postgrex](https://hexdocs.pm/postgrex/Postgrex.html)
- This module handles the connection to PostgreSQL, providing support for queries, transactions, connection backoff, logging, pooling and more.

[CORS](https://hex.pm/packages/cors_plug)
- An Elixir Plug that adds Cross-Origin Resource Sharing (CORS) headers to requests and responds to preflight requests (OPTIONS).

[Guardian](https://github.com/ueberauth/guardian)
- Guardian is a token based authentication library for use with Elixir applications.

[HTTPoison](https://github.com/edgurgel/httpoison)
- HTTPoison uses hackney to execute HTTP requests instead of ibrowse. Using hackney we work only with binaries instead of string lists.

[Phoenix Swagger](https://github.com/xerions/phoenix_swagger)
- PhoenixSwagger is the library that provides swagger integration to the phoenix web framework. Use `mix swagger` to generate swagger.json file with all specification.

[Running tests with ExUnit](https://hexdocs.pm/ex_unit/ExUnit.html)
* ExUnit - Unit testing framework for Elixir.
`mix test --color`

[Verifying Lint with Credo](https://github.com/rrrene/credo)
* Credo is a static code analysis tool for the Elixir language with a focus on teaching and code consistency.
`mix credo --strict`

[Documentation](https://github.com/akoutmos/doctor)
* Ensure that your documentation is healthy with Doctor! This library contains a mix task that you can run against your project to generate a documentation coverage report.
`mix doctor --summary`

[Using Dialyzer in Elixir](https://github.com/jeremyjh/dialyxir)
* The Dialyzer, a DIscrepancy AnalYZer for ERlang programs. Dialyzer is a static analysis tool used for checking types and other discrepancies such as dead or unreachable code. Dialyzer examines .erl or .beam files (not .ex or .exs) – more on this in a minute.
`mix dialyzer`

[CI/CD Github - ACT](https://github.com/nektos/act)
* Run your GitHub Actions locally! Before submitting a contribution, run ACT locally to verify testing and code quality.
```
# Run the default (`push`) event:
act
```

## Development
C2C requires some steps, to help you, lets use Vagrant!
- Clone the project and access the folder c2c-elixir, then execute:
```sh
vagrant up
```
- Now, lets access the created vagrant machine.
```sh
vagrant ssh
```
- Ok, lets access the project:
```sh
cd /c2c-elixir
```
- Install dependencies 
```sh
mix deps.get
```
- Verify if all occurs right.
```sh
elixir -v #check was installed
sudo -u postgres psql #access postgres
```
- Let's create our database, tables and seeds.
```sh
mix ecto.setup #create database
mix ecto.migrate #execute all migration
mix run priv/repo/seeds.exs #persist initial data in database
```
- All right? So let's start the application
```sh
mix mix phx.server
```
Yay! 

Ready to run in production? 
- `MIX_ENV=prod mix phx.server`

# Demo
> [c2c-alixir](https://c2c-elixir.herokuapp.com/)
>
For now, C2C work only with [API Layer](https://apilayer.com/), just create an account, get your apikey and url endpoint.
``` 
apikey example: "gD4V9Ga0jeefzhCxn1yeIDTsOSQ18qJ"
url example: "https://api.apilayer.com/currency_data/convert?to=to&from=from&amount=amount"
```
> Note: Before register the url in C2C, you need modify to format:
> ``https://api.apilayer.com/currency_data/convert?to=:to&from=:from&amount=:amount``
- C2C use binds :from, :to and :amount

## License

MIT

**Free Software, Hell Yeah!**
