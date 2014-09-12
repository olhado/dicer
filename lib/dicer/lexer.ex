defmodule Dicer.Lexer do
  def process_next_token(input) when is_binary(input) do
    _process_next_token(input)
  end

  defp _process_next_token(input) do
    cond do
      Regex.match?(Dicer.Tokens.Plus.get_regex, input)
        ->
          %Dicer.Tokens.Plus{}
      Regex.match?(Dicer.Tokens.Minus.get_regex, input)
        ->
          %Dicer.Tokens.Minus{}
      Regex.match?(Dicer.Tokens.Multiply.get_regex, input)
        ->
          %Dicer.Tokens.Multiply{}
      Regex.match?(Dicer.Tokens.Divide.get_regex, input)
        ->
          %Dicer.Tokens.Divide{}
      Regex.match?(Dicer.Tokens.Exponent.get_regex, input)
        ->
          %Dicer.Tokens.Exponent{}
      Regex.match?(Dicer.Tokens.Dice.get_regex, input)
        ->
          %Dicer.Tokens.Dice{}
      Regex.match?(Dicer.Tokens.Num.get_regex, input)
        ->
          [head | _tail] = Regex.run(Dicer.Tokens.Num.get_regex, input)
          {num, _} = Float.parse(head)
          %Dicer.Tokens.Num{value: num}
      Regex.match?(Dicer.Tokens.LeftParenthesis.get_regex, input)
        ->
          %Dicer.Tokens.LeftParenthesis{}
      Regex.match?(Dicer.Tokens.RightParenthesis.get_regex, input)
        ->
          %Dicer.Tokens.RightParenthesis{}
      Regex.match?(Dicer.Tokens.End.get_regex, input)
        ->
          %Dicer.Tokens.End{}
      true
        -> raise "Unknown Token!"
    end
  end
end