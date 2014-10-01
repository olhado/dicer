defmodule Dicer.Parser do
  def evaluate(input) when is_list(input) do
    _expression(input)
  end

### Expressions
  defp _expression(input) do
    {remaining_input, num} = _factor(input)
    _additives(remaining_input, num)
  end

  defp _additives([%Dicer.Tokens.Plus{} | tail], acc) do
      {remaining_input, factor1} = _factor(tail)
      _additives(remaining_input, acc + factor1)
  end

  defp _additives([%Dicer.Tokens.Minus{} | tail], acc) do
      {remaining_input, factor1} = _factor(tail)
      _additives(remaining_input, acc - factor1)
  end

  defp _additives(input, acc) do
      {input, acc}
  end

### Factors
  defp _factor(input) do
    {remaining_input, num} = _number_or_dice(input)
    _multiplicatives(remaining_input, num)
  end

  defp _multiplicatives([%Dicer.Tokens.Multiply{} | tail], acc) do
    {remaining_input, num} = _number_or_dice(tail)
    _multiplicatives(remaining_input, acc * num)
  end

  defp _multiplicatives([%Dicer.Tokens.Divide{} | tail], acc) do
     {remaining_input, num} = _number_or_dice(tail)
      _multiplicatives(remaining_input, acc / num)
  end

  defp _multiplicatives(input, acc) do
      {input, acc}
  end

### Numbers/Dice
  defp _number_or_dice([%Dicer.Tokens.LeftParenthesis{} | tail]) do
    {remaining_input, num} = _expression(tail)
    case hd(remaining_input) do
      %Dicer.Tokens.RightParenthesis{} ->
        {tl(remaining_input), num}
      _ ->
        raise "Missing closing parenthesis!"
    end
  end

  defp _number_or_dice(input = [%Dicer.Tokens.Dice{} | tail]) do
    dice_rolls = hd(input)
    {tail, Enum.sum(dice_rolls.values)}
  end

  defp _number_or_dice(input = [%Dicer.Tokens.Num{} | tail]) do
    num = Dicer.Tokens.Num.convert_to_float(hd(input))
    {tail, num}
  end

  defp _number_or_dice(input) do
    {input, 0.0}
  end
end