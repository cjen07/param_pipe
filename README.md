# ParamPipe

## Prerequisite
* Erlang v21.0
* Elixir v1.7.3

## Installation

```elixir
def deps do
  [
    {:param_pipe, "~> 0.2.0"}
  ]
end
```

## Tests

```elixir
  mix test
```

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

  # assigning a variable within the pipe operator is supported

  def bar3() do
    h =
      1
      |-2> foo(0, 0) = f # 3 = f
      |-1> foo(0, 0) # 12
      |> foo(0, 0) = g # 24 = g
      |-1> foo(0, 0) # 96
      |> foo(f, g) # 297
    h
  end
```
