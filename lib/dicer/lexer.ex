defmodule Dicer.Lexer do
  alias Dicer.Tokens

  def tokenize({:ok, input}) when is_binary(input) do
    _tokenize(input)
  end

  def tokenize(input = {:error, _}) do
    input
  end

  defp _tokenize(input, result \\ [])
  defp _tokenize("", result) do
    {:ok, Enum.reverse([%Tokens.End{}] ++ result)}
  end

  defp _tokenize(input, result) do
    case _process_next_token(input) do
      {:error, message} -> {:error, message}

      {token, remaining_input} -> _tokenize(remaining_input,  [token] ++ result)
    end
  end

  defp _process_next_token(input) do
    cond do
      Regex.match?(Tokens.Plus.get_regex, input) ->
        {%Tokens.Plus{}, String.slice(input, 1..-1)}

      Regex.match?(Tokens.Minus.get_regex, input) ->
        {%Tokens.Minus{}, String.slice(input, 1..-1)}

      Regex.match?(Tokens.Multiply.get_regex, input) ->
        {%Tokens.Multiply{}, String.slice(input, 1..-1)}

      Regex.match?(Tokens.Divide.get_regex, input) ->
        {%Tokens.Divide{}, String.slice(input, 1..-1)}

      Regex.match?(Tokens.LeftParenthesis.get_regex, input) ->
        {%Tokens.LeftParenthesis{}, String.slice(input, 1..-1)}

      Regex.match?(Tokens.RightParenthesis.get_regex, input) ->
        {%Tokens.RightParenthesis{}, String.slice(input, 1..-1)}

      Regex.match?(Tokens.Dice.get_regex, input) ->
        _process_and_create_dice_token(input)

      Regex.match?(Tokens.Num.get_regex, input) ->
        [num_str | _tail] = Regex.run(Tokens.Num.get_regex, input)
        {%Tokens.Num{value: num_str}, String.slice(input, String.length(num_str)..-1)}

      String.length(input) == 0 -> {%Tokens.End{}, ""}

      true -> {:error, "Invalid Token!"}
    end
  end

  defp _process_and_create_dice_token(input) do
    [_, dice_str, quantity, sides] = Regex.run(Tokens.Dice.get_regex, input)
    {s, _} = Integer.parse sides

    case quantity do
      "" -> 1

      _ ->
        {result, _} = Integer.parse quantity
        {%Tokens.Dice{quantity: result, sides: s }, String.slice(input, String.length(dice_str)..-1)}
    end
  end
end