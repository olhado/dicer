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

  def roll(input) do
    input
    |> Validator.validate
    |> Lexer.tokenize
    |> Roller.roll_dice
    |> Parser.evaluate
  end

  defp _sanitize(input) do
    String.replace(input, ~r/\s/, "")
  end
end