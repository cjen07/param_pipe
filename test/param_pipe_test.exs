defmodule ParamPipeTest do
  use ExUnit.Case
  doctest ParamPipe

  test "greets the world" do
    assert ParamPipe.hello() == :world
  end
end
