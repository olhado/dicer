defmodule Dicer.Parser2 do

  def parse2(input) when is_binary(input) do
    input
    |> Dicer.Lexer.tokenize
    |> _parse2
  end

  defp _parse2(input, acc \\ 0.0)
  defp _parse2(input, acc) when is_list(input) do
    result = _expression2(input, acc)

    IO.puts result
  end

  defp _expression2(input, acc)
  defp _expression2([%Dicer.Tokens.Plus{} | tail], acc) do
      _expression2(tl(tail), acc + _number2(hd(tail)))
  end

  defp _expression2([%Dicer.Tokens.Minus{} | tail], acc) do
      _expression2(tl(tail), acc - _number2(hd(tail)))
  end

  defp _expression2([%Dicer.Tokens.End{} | nil], acc) do
    acc
  end

  defp _expression2([ | tail], acc) do
      _expression2(tail, acc + _number2(token))
  end

  defp _expression2(_, _acc) do
    raise "Invalid Expression!"
  end

  defp _number2(num = %Dicer.Tokens.Num{}) do
    Dicer.Tokens.Num.convert_to_float(num)
  end

  defp _number2(_) do
    raise "Not A Number!"
  end

  def parse(input) when is_binary(input) do

    {result, new_input} = _expression(input)

    cond do
      {%Dicer.Tokens.End{}, ""} == Dicer.Lexer.process_next_token(new_input)
        -> IO.puts result
      true
        -> raise "Expected End Token!"
    end
  end

  defp _expression(input) do
    {num_token, remaining_input} = _number(input)
    {num_val, _} = Float.parse(num_token.value)

    _expression(num_val, num_token, Dicer.Lexer.process_next_token(remaining_input))
  end

  defp _expression(acc, _previous_token, {%Dicer.Tokens.Plus{}, input}) do
    {num_token, remaining_input} = _number(input)
    {num_val, _} = Float.parse(num_token.value)

    _expression(acc + num_val, num_token, Dicer.Lexer.process_next_token(remaining_input))
  end

  defp _expression(acc, _previous_token, {%Dicer.Tokens.Minus{}, input}) do
    {num_token, remaining_input} = _number(input)
    {num_val, _} = Float.parse(num_token.value)

    _expression(acc - num_val, num_token, Dicer.Lexer.process_next_token(remaining_input))
  end

  defp _expression(acc, _previous_token, {%Dicer.Tokens.End{}, _input}) do
    {Float.round(acc,4), ""}
  end

  defp _number(input) do
    {num_token, remaining_input} = Dicer.Lexer.process_next_token(input)

    case num_token do
      %Dicer.Tokens.Num{}
        -> {num_token, remaining_input}
      _
        -> raise "Not A Number!"
    end
  end
end