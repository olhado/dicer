defmodule Dicer do
  alias Dicer.Validator
  alias Dicer.Lexer
  alias Dicer.Roller
  alias Dicer.Parser

  def roll(input) when is_binary(input) do
    input
    |> _sanitize
    |> Validator.validate
    |> Lexer.tokenize
    |> Roller.roll_dice
    |> Parser.evaluate
  end

  def roll(_input) do
    {:error, ["Not a string!"]}
  end

  def roll!(input) when is_binary(input) do
    result = 
      input
      |> roll

    case result do
      {:error, messages} ->
        raise "\n" <> Enum.join(messages, "\n") <> "\n"
      _ ->
        result
    end
  end

  def roll!(_input) do
    raise "Not a string!"
  end

  defp _sanitize(input) do
    String.replace(input, ~r/\s/, "")
  end
end