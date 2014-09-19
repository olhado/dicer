defmodule Dicer.Lexer do

  def tokenize(input) when is_binary(input) do
    _tokenize(input)
  end

  defp _tokenize(input, result \\ [])
  defp _tokenize("", result) do
    result ++ [%Dicer.Tokens.End{}]
  end

  defp _tokenize(input, result) do
    {token, remaining_input} = _process_next_token(input)
    _tokenize(remaining_input, result ++ [token])
  end

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
          _process_and_create_dice_token(input)
      Regex.match?(Dicer.Tokens.Num.get_regex, input)
        ->
          [num_str | _tail] = Regex.run(Dicer.Tokens.Num.get_regex, input)
          {%Dicer.Tokens.Num{value: num_str}, String.slice(input, String.length(num_str)..-1)}
      Regex.match?(Dicer.Tokens.LeftParenthesis.get_regex, input)
        ->
          {%Dicer.Tokens.LeftParenthesis{}, String.slice(input, 1..-1)}
      Regex.match?(Dicer.Tokens.RightParenthesis.get_regex, input)
        ->
          {%Dicer.Tokens.RightParenthesis{}, String.slice(input, 1..-1)}
      String.length(input) == 0
        ->
          {%Dicer.Tokens.End{}, ""}
      true
        -> raise "Unknown Token!"
    end
  end

  defp _process_and_create_dice_token(input) do
    [_, dice_str, quantity, sides] = Regex.run(Dicer.Tokens.Dice.get_regex, input)
    {s, _} = Integer.parse sides

    q = case quantity do
      ""  -> 1
      _   -> 
        {result, _} = Integer.parse quantity
        result
    end
    {%Dicer.Tokens.Dice{quantity: q, sides: s }, String.slice(input, String.length(dice_str)..-1)}
  end
end