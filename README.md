# ParamPipe

## parameterized pipe in elixir: |n>

```elixir
  use ParamPipe

  def foo(a, b, c) do
    a*2 + b*3 + c*4
  end

  def bar0() do
    100 |> div(5) |> div(2) # 10
  end

  # negative n in |n> is supported 

  def bar1() do
    1 |0> foo(0, 0) |1> foo(0, 0) |-1> foo(0, 0) # 24
  end

  # mixed usage with |> is supported

  def bar2() do
    1 
    |> foo(0, 0) # 2
    |1> foo(0, 0) # 6
    |> div(2) # 3
    |> div(3) # 1
    |2> foo(0, 0) # 4
    |> (fn x -> foo(0, 0, x) end).() # 16
    |-1> foo(0, 0) # 64
  end
```

