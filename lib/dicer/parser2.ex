defmodule Dicer.Parser2 do
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