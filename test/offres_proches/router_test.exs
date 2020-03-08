defmodule OffresProches.RouterTest do
  use ExUnit.Case
  use Plug.Test

  alias OffresProches.Router

  describe "Basic routes" do
    test "returns welcome" do
      conn =
        :get
        |> conn("/", "")
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 200
    end

    test "returns 404" do
      conn =
        :get
        |> conn("/missing", "")
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 404
    end
  end

  describe "Parameters verification" do
    test "Exception when a parameter is missing" do
      assert_raise OffresProches.VerifyRequest.IncompleteRequestError, fn ->
        conn =
          :get
          |> conn("/offres_proches", "")
          |> Router.call(@opts)
      end
    end

    test "Exception when the number of parameters is correct but the keys names are not" do
      assert_raise OffresProches.VerifyRequest.IncompleteRequestError, fn ->
        conn =
          :get
          |> conn("/offres_proches?param1=10.01&param2=10.03&param3=10", "")
          |> Router.call(@opts)
      end
    end

    test "No exception when parameters are ok" do
      conn =
        :get
        |> conn("/offres_proches?lat=10.01&lon=10.03&rad=10", "")
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 201
    end
  end
end
