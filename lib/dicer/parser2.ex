defmodule Dicer.Parser2 do

  def parse(input) when is_binary(input) do
    input
    |> Dicer.Lexer.tokenize
    |> _parse
    |> IO.puts
  end

  defp _parse(input, acc \\ 0.0)
  defp _parse(input, acc) when is_list(input) do
    _expression(input, acc)
  end

### Expressions
  defp _expression([%Dicer.Tokens.Plus{} | tail], acc) do
      {factor1, remaining_input} = _factor(tail, 0.0)
      _expression(remaining_input, acc + factor1)
  end

  defp _expression([%Dicer.Tokens.Minus{} | tail], acc) do
      {factor1, remaining_input} = _factor(tail, 0.0)
      _expression(remaining_input, acc - factor1)
  end

  defp _expression([%Dicer.Tokens.End{} | _], acc) do
    acc
  end

  defp _expression(input, _acc) do
      {factor1, remaining_input} = _factor(input, 0.0)
      _expression(remaining_input, factor1)
  end

### Factors
  defp _factor([%Dicer.Tokens.Multiply{} | tail], acc) do
    {num, remaining_input} = _number_or_dice(tail)
    _factor(remaining_input, acc * num)
  end

  defp _factor([%Dicer.Tokens.Divide{} | tail], acc) do
     {num, remaining_input} = _number_or_dice(tail)
      _factor(remaining_input, acc / num)
  end

  defp _factor(input = [%Dicer.Tokens.End{} | _], acc) do
    {acc, input}
  end

  defp _factor(input, _acc) do
    {num, remaining_input} = _number_or_dice(input)
    _factor(remaining_input, num)
  end

### Numbers
  defp _number_or_dice(num = %Dicer.Tokens.Num{}) do
    Dicer.Tokens.Num.convert_to_float(num)
  end

  defp _number_or_dice(num = %Dicer.Tokens.Dice{}) do
    666
  end

  defp _number_or_dice(_) do
    raise "Not A Number!"
  end
end