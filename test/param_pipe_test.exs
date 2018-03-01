defmodule ParamPipeTest do
  use ExUnit.Case
  doctest ParamPipe

  test "welcome to param_pipe" do
    assert Q.bar1() == 24
    assert Q.bar2() == 64
    assert Q.bar3() == 297
  end
end
