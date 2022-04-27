defmodule C2cWeb.ApiCurrencyControllerTest do
  use C2cWeb.ConnCase

  import C2c.ApiCurrenciesFixtures

  @create_attrs %{
    api_key: "some api_key",
    description: "some description",
    limit: 42,
    remaining_conversions: 42,
    url: "some url"
  }
  @update_attrs %{
    api_key: "some updated api_key",
    description: "some updated description",
    limit: 43,
    remaining_conversions: 43,
    url: "some updated url"
  }
  @invalid_attrs %{
    api_key: nil,
    description: nil,
    limit: nil,
    remaining_conversions: nil,
    url: nil
  }

  describe "index" do
    test "lists all api_currencies", %{conn: conn} do
      conn = get(conn, Routes.api_currency_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Api currencies"
    end
  end

  describe "new api_currency" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.api_currency_path(conn, :new))
      assert html_response(conn, 200) =~ "New Api currency"
    end
  end

  describe "create api_currency" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.api_currency_path(conn, :create), api_currency: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.api_currency_path(conn, :show, id)

      conn = get(conn, Routes.api_currency_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Api currency"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.api_currency_path(conn, :create), api_currency: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Api currency"
    end
  end

  describe "edit api_currency" do
    setup [:create_api_currency]

    test "renders form for editing chosen api_currency", %{conn: conn, api_currency: api_currency} do
      conn = get(conn, Routes.api_currency_path(conn, :edit, api_currency))
      assert html_response(conn, 200) =~ "Edit Api currency"
    end
  end

  describe "update api_currency" do
    setup [:create_api_currency]

    test "redirects when data is valid", %{conn: conn, api_currency: api_currency} do
      conn =
        put(conn, Routes.api_currency_path(conn, :update, api_currency),
          api_currency: @update_attrs
        )

      assert redirected_to(conn) == Routes.api_currency_path(conn, :show, api_currency)

      conn = get(conn, Routes.api_currency_path(conn, :show, api_currency))
      assert html_response(conn, 200) =~ "some updated api_key"
    end

    test "renders errors when data is invalid", %{conn: conn, api_currency: api_currency} do
      conn =
        put(conn, Routes.api_currency_path(conn, :update, api_currency),
          api_currency: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Edit Api currency"
    end
  end

  describe "delete api_currency" do
    setup [:create_api_currency]

    test "deletes chosen api_currency", %{conn: conn, api_currency: api_currency} do
      conn = delete(conn, Routes.api_currency_path(conn, :delete, api_currency))
      assert redirected_to(conn) == Routes.api_currency_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, Routes.api_currency_path(conn, :show, api_currency))
      end)
    end
  end

  defp create_api_currency(_) do
    api_currency = api_currency_fixture()
    %{api_currency: api_currency}
  end
end
