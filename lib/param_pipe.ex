defmodule ParamPipe do
  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__), only: [{:|, 2}]
    end
  end

  def unpipe(expr) do
    unpipe(expr, [])
  end

  defp unpipe({:|, _, [left, right]}, acc) do
    unpipe(left, unpipe(right, acc))
  end

  defp unpipe({:>, _, [left, right]}, acc) do
    case right do
      {:|>, _, _} ->
        [{h, _} | t] = Macro.unpipe(right) 
        [{h, left} | t] ++ acc
      _ ->
        case left do
          {:-, _, [n]} ->
            [{right, -n} | acc]
          _ -> 
            [{right, left} | acc]
        end
    end
  end

  defp unpipe(other, acc) do
    [{other, 0} | acc]
  end

  defmacro left | right do
    # similar to |> definiation
    [{h, _} | t] = unpipe({:|, [], [left, right]})
    :lists.foldl fn {x, pos}, acc ->
      # TODO: raise an error in `Macro.pipe/3` by 2.0
      case Macro.pipe_warning(x) do
        nil -> :ok
        message ->
          :elixir_errors.warn(__CALLER__.line, __CALLER__.file, message)
      end
      Macro.pipe(acc, x, pos)
    end, h, t
  end

end
