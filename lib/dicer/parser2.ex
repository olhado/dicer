defmodule Dicer.Parser2 do
  def parse(input) when is_binary(input) do
    input
    |> Dicer.Lexer.tokenize
    |> _parse
    |> IO.inspect
  end

  defp _parse(input, acc \\ 0.0)
  defp _parse(input, acc) when is_list(input) do
    << a :: 32, b :: 32, c :: 32 >> = :crypto.rand_bytes(12)
    :random.seed(a,b,c)
    _expression(input, acc)
  end

### Expressions
  defp _expression([%Dicer.Tokens.End{} | _], acc) do
    {[], acc}
  end

  defp _expression([%Dicer.Tokens.Plus{} | tail], acc) do
      {remaining_input, factor1} = _factor(tail, acc)
      _expression(remaining_input, acc + factor1)
  end

  defp _expression([%Dicer.Tokens.Minus{} | tail], acc) do
      {remaining_input, factor1} = _factor(tail, acc)
      _expression(remaining_input, acc - factor1)
  end

  defp _expression(input, acc) do
      {remaining_input, factor1} = _factor(input, acc)
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

  defp _factor(input, acc) do
    case _number_or_dice(input) do
      {remaining_input, :not_a_num} ->
        {remaining_input, acc}
      {remaining_input, num} ->
        _factor(remaining_input, num)
      true ->
        raise "Unexpected input!"
    end
  end

### Numbers/Dice
  # defp _number_or_dice([%Dicer.Tokens.LeftParenthesis{} | tail]) do
  #   {remaining_input, num} = _expression(tail, 0.0)
  # end

  # defp _number_or_dice([%Dicer.Tokens.RightParenthesis{} | tail]) do
    
  # end

  defp _number_or_dice(input = [%Dicer.Tokens.Dice{} | tail]) do
    {tail, _roll(hd(input))}
  end

  defp _number_or_dice(input = [%Dicer.Tokens.Num{} | tail]) do
    num = Dicer.Tokens.Num.convert_to_float(hd(input))
    {tail, num}
  end

  defp _number_or_dice(input) do
    {input, :not_a_num}
  end

  defp _roll(input = %Dicer.Tokens.Dice{}) do
    _roll(input.sides, input.quantity, 0)
  end

  defp _roll(_sides, 0, acc) do
    acc
  end

  defp _roll(sides, rolls_left, acc) do
    _roll(sides, rolls_left - 1, acc + :random.uniform(sides))
  end
end