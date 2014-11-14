defmodule Dicer do
  alias Dicer.Sanitizer
  alias Dicer.Validator
  alias Dicer.Lexer
  alias Dicer.Roller
  alias Dicer.Parser

  def roll(input) when is_binary(input) do
    input
    |> Sanitizer.sanitize
    |> Lexer.tokenize
    |> Validator.validate
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
end