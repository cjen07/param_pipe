defmodule ParamPipeTest do
  use ExUnit.Case
  doctest ParamPipe
  use ParamPipe

  test "welcome to param_pipe" do
    assert Q.bar1() == 24
    assert Q.bar2() == 64
    assert Q.bar3() == 297
  end

  def a1() do
    h =
      1
      |-2> Q.foo(0, 0) = f
      |> Q.foo(0, 0)
      |-2> Q.foo(0, 0)
    f+h
  end

  def a2() do
    h =
      1
      |-2> Q.foo(0, 0) = f
      |-2> Q.foo(0, 0)
      |> Q.foo(0, 0)
    f+h
  end

  def a3() do
    h =
      1
      |-2> Q.foo(0, 0) = f
      |> Q.foo(0, 0)
      |> Q.foo(0, 0)
    f+h
  end

  test "test suite a" do
    assert a1() == 21
    assert a2() == 21
    assert a3() == 15
  end

  def b1() do
    h =
      1..10
      |0> (fn x -> x end).() = f
      |> Enum.sum()
      |-2> Q.foo(0, 0)
    Enum.max(f) + h
  end

  test "test suite b" do
    assert b1() == 175
  end
end
