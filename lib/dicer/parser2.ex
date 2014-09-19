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
  defp _expression([%Dicer.Tokens.End{} | _], acc) do
    acc
  end

  defp _expression([%Dicer.Tokens.Plus{} | tail], acc) do
      {remaining_input, factor1} = _factor(tail, 0.0)
      _expression(remaining_input, acc + factor1)
  end

  defp _expression([%Dicer.Tokens.Minus{} | tail], acc) do
      {remaining_input, factor1} = _factor(tail, 0.0)
      _expression(remaining_input, acc - factor1)
  end

  defp _expression(input, _acc) do
      {remaining_input, factor1} = _factor(input, 0.0)
      _expression(remaining_input, factor1)
  end

### Factors
  defp _factor(input = [%Dicer.Tokens.End{} | _], acc) do
    {input, acc}
  end

  defp _factor([%Dicer.Tokens.Multiply{} | tail], acc) do
    {remaining_input, num} = _number_or_dice(tail)
    _factor(remaining_input, acc * num)
  end

  defp _factor([%Dicer.Tokens.Divide{} | tail], acc) do
     {remaining_input, num} = _number_or_dice(tail)
      _factor(remaining_input, acc / num)
  end

    defp _factor(input = [%Dicer.Tokens.Num{} | _], acc) do
      {remaining_input, num} = _number_or_dice(input)
      _factor(remaining_input, num)
  end

  defp _factor(input, _acc) do
    {remaining_input, num} = _number_or_dice(input)
    _factor(remaining_input, num)
  end

### Numbers/Dice
  defp _number_or_dice([%Dicer.Tokens.Dice{} | tail]) do
    {tail, 666}
  end

  defp _number_or_dice(input = [%Dicer.Tokens.Num{} | tail]) do
    num = Dicer.Tokens.Num.convert_to_float(hd(input))
    {tail, num}
  end

  defp _number_or_dice(_) do
    raise "Not A Number!"
  end
end