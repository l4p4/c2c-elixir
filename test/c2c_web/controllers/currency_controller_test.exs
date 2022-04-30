defmodule C2cWeb.CurrencyControllerTest do
  use C2cWeb.ConnCase, async: true

  alias C2c.Accounts
  alias C2cWeb.UserAuth
  import C2c.CurrenciesFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  setup %{conn: conn} do
    user = C2c.AccountsFixtures.user_fixture()

    conn =
      conn
      |> Map.replace!(:secret_key_base, C2cWeb.Endpoint.config(:secret_key_base))
      |> init_test_session(%{})

    user_token = Accounts.generate_user_session_token(user)
    conn = conn |> put_session(:user_token, user_token) |> UserAuth.fetch_current_user([])
    currency = currency_fixture()

    %{conn: conn, currency: currency}
  end

  describe "index" do
    test "lists all currencies", %{conn: conn} do
      conn = get(conn, Routes.currency_path(conn, :index))
      assert html_response(conn, 200) =~ "Currencies"
    end
  end

  describe "new currency" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.currency_path(conn, :new))
      assert html_response(conn, 200) =~ "New Currency"
    end
  end

  describe "create currency" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.currency_path(conn, :create), currency: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.currency_path(conn, :show, id)

      conn = get(conn, Routes.currency_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Currency"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.currency_path(conn, :create), currency: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Currency"
    end
  end

  describe "edit currency" do
    test "renders form for editing chosen currency", %{conn: conn, currency: currency} do
      conn = get(conn, Routes.currency_path(conn, :edit, currency))
      assert html_response(conn, 200) =~ "Edit Currency"
    end
  end

  describe "update currency" do
    test "redirects when data is valid", %{conn: conn, currency: currency} do
      conn = put(conn, Routes.currency_path(conn, :update, currency), currency: @update_attrs)
      assert redirected_to(conn) == Routes.currency_path(conn, :show, currency)

      conn = get(conn, Routes.currency_path(conn, :show, currency))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, currency: currency} do
      conn = put(conn, Routes.currency_path(conn, :update, currency), currency: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Currency"
    end
  end

  describe "delete currency" do
    test "deletes chosen currency", %{conn: conn, currency: currency} do
      conn = delete(conn, Routes.currency_path(conn, :delete, currency))
      assert redirected_to(conn) == Routes.currency_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, Routes.currency_path(conn, :show, currency))
      end)
    end
  end
end
