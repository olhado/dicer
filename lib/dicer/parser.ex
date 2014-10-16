defmodule Dicer.Parser do
  alias Dicer.Tokens

  def evaluate({:ok, input}) when is_list(input) do
    case _expression(input) do
      {[%Tokens.End{}], result} ->
        {:ok, result}

      {:error, error_details} ->
        {:error, error_details}

      _ ->
        {:error, "Unexpected error in parser!"}
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

      {remaining_input, num} -> _add_or_delete(remaining_input, num)
    end
  end

### _apply_expression/2 is a work in progress
  defp _apply_expression([head | tail], acc) when head == %Tokens.Plus{} or head == %Tokens.Minus{} do
    case _factor(tail) do
      {:error, message} -> {:error, message}

      {remaining_input, factor1} -> _apply_expression(remaining_input, head.function.(acc, factor1))
    end
  end

    defp _apply_expression(input, acc) do
    {input, acc}
  end

  defp _add_or_delete([%Tokens.Plus{} | tail], acc) do
    case _factor(tail) do
      {:error, message} -> {:error, message}

      {remaining_input, factor1} -> _add_or_delete(remaining_input, acc + factor1)
    end
  end

  defp _add_or_delete([%Tokens.Minus{} | tail], acc) do
    case _factor(tail) do
      {:error, message} -> {:error, message}

      {remaining_input, factor1} -> _add_or_delete(remaining_input, acc - factor1)
    end  end

  defp _add_or_delete(input, acc) do
    {input, acc}
  end

### Factors
  defp _factor(input) do
    case _number_or_dice(input) do
      {:error, message} -> {:error, message}

      {remaining_input, num} -> _multiply_or_divide(remaining_input, num)
    end
  end

  defp _multiply_or_divide([%Tokens.Multiply{} | tail], acc) do
    case _number_or_dice(tail) do
      {:error, message} -> {:error, message}

      {remaining_input, num} -> _multiply_or_divide(remaining_input, acc * num)
    end
  end

  defp _multiply_or_divide([%Tokens.Divide{} | tail], acc) do
    case _number_or_dice(tail) do
      {:error, message} -> {:error, message}

      {remaining_input, num} -> _multiply_or_divide(remaining_input, acc / num)
    end
  end

  defp _multiply_or_divide(input, acc) do
    {input, acc}
  end

### Numbers/Dice
  defp _number_or_dice([%Tokens.LeftParenthesis{} | tail]) do
    {remaining_input, num} = _expression(tail)
    case hd(remaining_input) do
      %Tokens.RightParenthesis{} ->
        {tl(remaining_input), num}
      
      _ ->
        {:error, "Missing closing parenthesis!"}
    end
  end

  defp _number_or_dice(input = [%Tokens.Dice{} | tail]) do
    dice_rolls = hd(input)
    {tail, Enum.sum(dice_rolls.values)}
  end

  defp _number_or_dice(input = [%Tokens.Num{} | tail]) do
    num = Tokens.Num.convert_to_float(hd(input))
    {tail, num}
  end

  defp _number_or_dice([%Tokens.RightParenthesis{} | _tail]) do
    {:error, "Missing opening parenthesis!"}
  end
end