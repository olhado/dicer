defmodule Dicer do
  alias Dicer.Validator
  alias Dicer.Lexer
  alias Dicer.Roller
  alias Dicer.Parser

  def roll(input) when is_binary(input) do
    input
    |> Validator.sanitize
    |> Lexer.tokenize
    |> Roller.roll_dice
    |> Parser.evaluate
  end
end