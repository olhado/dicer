defmodule Dicer.Lexer do
  def process_next_token(input) when is_binary(input) do
    _process_next_token(input)
  end

  defp _process_next_token(input) do
    cond do
      Regex.match?(Dicer.Tokens.Plus.get_regex, input)
        ->
          {%Dicer.Tokens.Plus{}, String.slice(input, 1..-1)}
      Regex.match?(Dicer.Tokens.Minus.get_regex, input)
        ->
          {%Dicer.Tokens.Minus{}, String.slice(input, 1..-1)}
      Regex.match?(Dicer.Tokens.Multiply.get_regex, input)
        ->
          {%Dicer.Tokens.Multiply{}, String.slice(input, 1..-1)}
      Regex.match?(Dicer.Tokens.Divide.get_regex, input)
        ->
          {%Dicer.Tokens.Divide{}, String.slice(input, 1..-1)}
      Regex.match?(Dicer.Tokens.Exponent.get_regex, input)
        ->
          {%Dicer.Tokens.Exponent{}, String.slice(input, 1..-1)}
      Regex.match?(Dicer.Tokens.Dice.get_regex, input)
        ->
          {%Dicer.Tokens.Dice{}, String.slice(input, 1..-1)}
      Regex.match?(Dicer.Tokens.Num.get_regex, input)
        ->
          [head | _tail] = Regex.run(Dicer.Tokens.Num.get_regex, input)
          {num, _} = Float.parse(head)
          {%Dicer.Tokens.Num{value: num}, String.slice(input, String.length(head)..-1)}
      Regex.match?(Dicer.Tokens.LeftParenthesis.get_regex, input)
        ->
          {%Dicer.Tokens.LeftParenthesis{}, String.slice(input, 1..-1)}
      Regex.match?(Dicer.Tokens.RightParenthesis.get_regex, input)
        ->
          {%Dicer.Tokens.RightParenthesis{}, String.slice(input, 1..-1)}
      Regex.match?(Dicer.Tokens.End.get_regex, input)
        ->
          {%Dicer.Tokens.End{}, ""}
      true
        -> raise "Unknown Token!"
    end
  end
end