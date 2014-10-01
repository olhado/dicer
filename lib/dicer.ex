defmodule Dicer do
  def roll(input) when is_binary(input) do
    input
    |> Dicer.Validator.sanitize
    |> Dicer.Lexer.tokenize
    |> Dicer.Roller.roll_dice
    |> Dicer.Parser2.evaluate
  end
end