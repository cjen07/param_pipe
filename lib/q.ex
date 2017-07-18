defmodule Q do
  use ParamPipe
  
  def foo(a, b, c) do
    a*2 + b*3 + c*4
  end

  def bar() do
    1 |0> foo(0, 0) |1> foo(0, 0) |2> foo(0, 0)
  end

end