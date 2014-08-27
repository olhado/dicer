defmodule Dicer.Parser do
  import Dicer.Validator

  @multiple_dice_regex ~r/^([\+\-\*\/]?)(\d+?)d(\d+)(.*)/i
  @single_die_regex ~r/^([\+\-\*\/]?)d(\d+)(.*)/i
  @scalar_regex ~r/^([\+\-\*\/]?)(\d+)(.*)/i
  @complex_regex ~r/^([\+\-\*\/]?)[\(]{1,1}([0-9d\-\*\+\/\(\)]+)[\)]{1,1}([\+\-\*\/]?.*)/i

  def parse(dice_str, false) do
    dice_str
    |> _strip_spaces
    |>_parse
  end

  def parse(dice_str, true) do
      case dice_str |> validate do
        {:ok, valid_str, []} ->
          valid_str
          |> _strip_spaces
          |> _parse

        {:error, _invalid_str, reason} ->
          IO.puts reason

        _ -> {:error, ["Unknown error!!!\n"]}
      end
  end

  defp _strip_spaces(dice_str), do: String.replace(dice_str, " ", "")

  defp _parse(dice_str, result \\ [])
  defp _parse(dice_str, result) do
    cond do
      match = Regex.run(@multiple_dice_regex, dice_str) ->
        _parse(List.last(match), [Dicer.Terms.Dice.new(match) | result])
      
      match = Regex.run(@single_die_regex, dice_str) ->
        die_list = List.insert_at(match, 2, "1")
        _parse(List.last(match), [Dicer.Terms.Dice.new(die_list) | result])
      
      match = Regex.run(@scalar_regex, dice_str) ->
        _parse(List.last(match), [Dicer.Terms.Scalar.new(match) | result])

      match = Regex.run(@complex_regex, dice_str) ->
        [_, _, terms, _] = match
        parsed_inner_terms = _parse(terms)
        _parse(List.last(match), [Dicer.Terms.Complex.new(match, parsed_inner_terms) | result])

      true -> 
        Enum.reverse(result)
    end
  end
end