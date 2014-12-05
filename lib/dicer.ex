defmodule Dicer do
  alias Dicer.Sanitizer
  alias Dicer.Validator
  alias Dicer.Lexer
  alias Dicer.Roller
  alias Dicer.Parser

  def roll(input, validation_options \\ %{max_dice: 1_000_000, max_sides: 1_000_000})
  def roll(input, validation_options) when is_binary(input) and is_map(validation_options) do
    input
    |> Sanitizer.sanitize
    |> Lexer.tokenize
    |> Validator.validate(validation_options)
    |> Roller.roll_dice
    |> Parser.evaluate
  end

  def roll(_input, _validation_options) do
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