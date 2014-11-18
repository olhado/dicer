defmodule Dicer.Parser do
  alias Dicer.Tokens

  def evaluate({:ok, input}) when is_list(input) do
    IO.inspect input
    
    case _expression(input) do
      {[%Tokens.End{}], result} ->
        {:ok, input, result}

      {:error, error_details} ->
        {:error, error_details}

      _ ->
        {:error, ["Unexpected error in parser!"]}
    end
  end

  def evaluate(input = {:error, _}) do
    input
  end

### Expressions
  defp _expression([%Tokens.End{}]) do
    {[%Tokens.End{}], 0.0}
  end

  defp _expression(input) do
    case _factor(input) do
      {:error, message} -> {:error, message}

      {remaining_input, num} -> _apply_expression(remaining_input, num)
    end
  end

  ### TODO: Jose sez guard is ugly until Erlang (and thus Elixir) support accessing map fields in guards
  ### (https://groups.google.com/d/msg/elixir-lang-talk/rprxcoQERbA/La08lNry81AJ)
  defp _apply_expression([head = %{__struct__: var} | tail], acc) when var in [Tokens.Plus] or var in [Tokens.Minus] do
    case _factor(tail) do
      {:error, message} -> {:error, message}

      {remaining_input, factor} -> _apply_expression(remaining_input, head.function.(acc, factor))
    end
  end

    defp _apply_expression(input, acc) do
    {input, acc}
  end

### Factors
  defp _factor(input) do
    case _number_or_dice(input) do
      {:error, message} -> {:error, message}

      {remaining_input, num} -> _apply_factor(remaining_input, num)
    end
  end

  ### TODO: Jose sez guard is ugly until Erlang (and thus Elixir) support accessing map fields in guards
  ### (https://groups.google.com/d/msg/elixir-lang-talk/rprxcoQERbA/La08lNry81AJ)
  defp _apply_factor([head = %{__struct__: var} | tail], acc) when var in [Tokens.Multiply] or var in [Tokens.Divide] do
    case _number_or_dice(tail) do
      {:error, message} -> {:error, message}

      # Catch divide by zero errors
      {remaining_input, num} -> 
        try do
          calculation = head.function.(acc, num)
          _apply_factor(remaining_input, calculation)
        rescue
          e in ArithmeticError -> {:error, [Exception.message(e)]}
       end
    end
  end

  defp _apply_factor(input, acc) do
    {input, acc}
  end

### Numbers/Dice
  defp _number_or_dice([%Tokens.LeftParenthesis{} | tail]) do
    case _expression(tail) do
      {:error, ["Missing opening parenthesis!"]} ->
        {:error, ["Unbalanced parentheses!"]} 

      result = {:error, _} ->
        result

      {remaining_input, num} ->
        case hd(remaining_input) do
          %Tokens.RightParenthesis{} ->
            {tl(remaining_input), num}

          _ ->
            {:error, ["Missing closing parenthesis!"]}
        end
    end
  end

  defp _number_or_dice(input = [%Tokens.Dice{} | tail]) do
    dice_rolls = hd(input)
    {tail, Enum.sum(dice_rolls.counted_values)}
  end

  defp _number_or_dice(input = [%Tokens.FudgeDice{} | tail]) do
    dice_rolls = hd(input)
    {tail, Enum.sum(dice_rolls.counted_values)}
  end

  defp _number_or_dice(input = [%Tokens.Num{} | tail]) do
    num = Tokens.Num.convert_to_float(hd(input))
    {tail, num}
  end

  defp _number_or_dice([%Tokens.RightParenthesis{} | _tail]) do
    {:error, ["Missing opening parenthesis!"]}
  end

  defp _number_or_dice(input) do
    {input, 0.0}
  end
end