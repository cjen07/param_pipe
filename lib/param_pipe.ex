defmodule ParamPipe do
  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__), only: [{:|, 2}]
    end
  end

  def parse_index(expr) do
    case expr do
      {:-, _, [n]} ->
        -n
      _ ->
        expr
    end
  end

  def unpipe(expr) do
    unpipe(expr, [])
  end

  defp unpipe({:=, l, [left, {:|>, _, _} = right]}, acc) do
    [{h, _} | t] = Macro.unpipe(right)
    acc = t ++ acc
    unpipe({:=, l, [left, h]}, acc)
  end

  defp unpipe({:=, _, [left, right]}, acc) do
    case left do
      {:>, _, [index, code]} ->
        l = parse_index(index)
        case code do
          {:|>, _, _} ->
            [{h, _} | t] = Macro.unpipe(code)
            [{h, l} | t] ++ [{{:=, [], [right]}, 1}, {right, 0}] ++ acc
          _ ->
            [{code, l}, {{:=, [], [right]}, 1}, {right, 0}] ++ acc
        end
      _ ->
        [{right, 0} | acc] ++ [{{:=, [], [left]}, 1}]
    end
  end

  defp unpipe({:|, _, [left, right]}, acc) do
    unpipe(left, unpipe(right, acc))
  end

  defp unpipe({:>, _, [left, right]}, acc) do
    l = parse_index(left)
    case right do
      {:|>, _, _} ->
        [{h, _} | t] = Macro.unpipe(right)
        [{h, l} | t] ++ acc
      _ ->
        [{right, l} | acc]
    end
  end

  defp unpipe(other, acc) do
    [{other, 0} | acc]
  end

  defmacro left | right do
    unpipe({:|, [], [left, right]})
    |> Enum.reduce({[], []}, fn x, {a, cc} ->
      case elem(x, 0) do
        {_, _, nil} ->
          {[x], [a | cc]}
        _ ->
          {[x | a], cc}
      end
    end)
    |> (fn {a, cc} ->
      [a | cc]
      |> Enum.map(&Enum.reverse/1)
      |> Enum.reverse()
    end).()
    |> (fn [h | t] ->
      case h do
        [] -> t
        _ -> [h | t]
      end
    end).()
    |> Enum.map(fn [{h, _} | t] ->
      :lists.foldl fn {x, pos}, acc ->
        {call, line, arg} = x
        cond do
          call != := -> Macro.pipe(acc, x, pos)
          true ->
            {_, l, a} = Macro.pipe(acc, {:helper, line, arg}, pos)
            {:=, l, a}
        end
      end, h, t
    end)
    |> (fn x -> {:__block__, [], x} end).()
  end

end
