defmodule Agala.ConnTest do
  use ExUnit.Case

  alias Agala.{Conn}

  setup do
    %{conn: %Agala.Conn{
      request: %{},
      response: nil,
      halted: false,
      request_bot_params: %Agala.BotParams{},
      responser_name: "test"
      }}
    end

  describe "Agala.Conn :" do
    test ": access is working proper", %{conn: conn} do
      assert {:ok, %{}} = Access.fetch(conn, :request)
      assert {:ok, false} = Access.fetch(conn, :halted)
      assert {:ok, %Agala.BotParams{}} = Access.fetch(conn, :request_bot_params)

      assert %Agala.BotParams{} = Access.get(conn, :request_bot_params)
      assert nil == Access.get(conn, :foo)

      assert {false, %{halted: true}} = Access.get_and_update(conn, :halted, fn _ -> {false, true} end)

      assert {false, %{halted: false}} = Access.pop(conn, :halted)
    end

    test ": halt is working properly" do
      assert %{halted: true} = Conn.halt(%Agala.Conn{halted: false})
    end

    test ": send_to is working properly", %{conn: conn} do
      assert %{responser_name: "foo"} = Conn.send_to(conn, "foo")
    end

    test ": with_fallback is working properly", %{conn: conn} do
      fun = fn conn -> conn.responser_name end

      %{fallback: fun_from_conn} = Conn.with_fallback(conn, fun)

      assert "test" = fun_from_conn.(conn)
    end

    test ": assigns is working properly", %{conn: conn} do
      assert nil == conn.assigns[:hello]
      conn = Conn.assign(conn, :hello, "world")
      assert "world" == conn.assigns[:hello]
    end

    test ": put_private is working properly", %{conn: conn} do
      assert nil == conn.private[:hello]
      conn = Conn.put_private(conn, :hello, "world")
      assert "world" == conn.private[:hello]
    end
  end
end
