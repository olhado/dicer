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
     {term1, remaining_input} = _term(tail, 0.0)
      _factor(remaining_input, acc * term1)
  end

  defp _factor([%Dicer.Tokens.Divide{} | tail], acc) do
     {term1, remaining_input} = _term(tail, 0.0)
      _factor(remaining_input, acc / term1)
  end

  defp _factor(input =[%Dicer.Tokens.Num{} | tail], _acc) do
      num = _number(hd(input))
      _factor(tail, num)
  end

  defp _factor(input, _acc) do
      {factor1, remaining_input} = _factor(input, 0.0)
      _factor(remaining_input, factor1)
  end

### Terms
  defp _term(input = [%Dicer.Tokens.Dice{} | tail], _acc) do
      num = _roll(hd(input))
      _term(tl(tail), num)
  end

  defp _term(input =[ %Dicer.Tokens.Num{} | tail], _acc) do
      num = _number(hd(input))
      _term(tail, num)
  end

  defp _term(input, acc) do
    {acc, input}
  end

### Dice
  defp _roll(dice, acc \\0)
  defp _roll(%Dicer.Tokens.Dice{quantity: quantity}, acc) when quantity == 0 do
    acc
  end
  defp _roll(dice = %Dicer.Tokens.Dice{}, acc) do
    # TODO: ADD ROLLING HERE
    _roll(%Dicer.Tokens.Dice{quantity: dice.quantity - 1, sides: dice.sides}, acc + 1)
  end

### Numbers
  defp _number(num = %Dicer.Tokens.Num{}) do
    Dicer.Tokens.Num.convert_to_float(num)
  end

  defp _number(_) do
    raise "Not A Number!"
  end
end