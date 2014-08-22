defmodule Dice.Parser do
  # Fix regex to accept single digit
  @valid_chars_regex ~r/^[0-9d\-\+\(]{1,1}[0-9d\-\+\*\/\(\)]*?[0-9\)]{1,1}$/i

  @multiple_dice_regex ~r/^([\+\-\*\/]?)(\d+?)d(\d+)(.*)/i
  @single_die_regex ~r/^([\+\-\*\/]?)d(\d+)(.*)/i
  @scalar_regex ~r/^([\+\-\*\/]?)(\d+)(.*)/i
  @complex_regex ~r/^([\+\-\*\/]?)[\(]{1,1}([0-9d\-\*\+\/\(\)]+)[\)]{1,1}([\+\-\*\/]?.*)/i

  def parse(dice_str, validate \\ true)
  def parse(dice_str, true) when is_binary(dice_str) and dice_str != "" do
      validation_result = dice_str |> _strip_spaces |> _validate

      case validation_result do
        {:ok, valid_str, []} ->
          valid_str |> _strip_spaces |> _parse

        {:error, _invalid_str, reason} ->
          IO.puts reason

        _ -> {:error, ["Unknown error!!!\n"]}
      end
  end

  def parse(dice_str, false) when is_binary(dice_str) and dice_str != "" do
    dice_str |> _strip_spaces |> _parse
  end

  defp _strip_spaces(dice_str) do
    String.replace(dice_str, " ", "")
  end

  defp _validate(dice_str) do
    {:ok, dice_str, []}
    |> _valid_chars
    |> _correct_num_of_parens
    |> _empty_parens_clauses
  end

  defp _valid_chars(validation_tuple = {_, dice_str, messages}) do
    valid_str = Regex.match?(@valid_chars_regex, dice_str)

    cond do
      !valid_str  -> {:error, dice_str, ["Dice string is not formatted correctly!\n" | messages]}
      valid_str   -> validation_tuple
    end
  end

  defp _correct_num_of_parens(validation_tuple = {_, dice_str, messages}) do
    case _count_parens(dice_str, 0) do
        {:early_end, _} ->
          {:error, dice_str, ["Closing parenthesis does not match any opening parenthesis!\n" | messages]}

        {:full_scan, parens_count} when parens_count < 0 ->
          {:error, dice_str, ["Closing parenthesis does not match any opening parenthesis!\n" | messages]}

        {:full_scan, parens_count} when parens_count > 0 ->
          {:error, dice_str, ["Opening parenthesis does not match any closing parenthesis!\n" | messages]}

        _ -> validation_tuple
    end
  end

  defp _count_parens("", parens_count) do
    {:full_scan, parens_count}
  end

  defp _count_parens(_str, parens_count) when parens_count < 0 do
    {:early_end, parens_count}
  end

  defp _count_parens(<< "(", str :: binary >>, parens_count) do
    _count_parens(str, parens_count + 1)
  end

  defp _count_parens(<< ")", str :: binary >>, parens_count) do
    _count_parens(str, parens_count - 1)
  end

  defp _count_parens(<< _, str :: binary >>, parens_count) when is_binary(str) do
    _count_parens(str, parens_count)
  end

  defp _empty_parens_clauses(validation_tuple = {_, dice_str, messages}) do
    if Regex.match?(~r/\(\)/i, dice_str) do
      {:error, dice_str, ["Empty clause in input!\n" | messages]}
    else
      validation_tuple
    end
  end

  defp _parse(dice_str, result \\ [])
  defp _parse(dice_str, result) do
    cond do
      match = Regex.run(@multiple_dice_regex, dice_str) ->
        _parse(List.last(match), [Dice.ParsedDiceTerm.new(match) | result])
      
      match = Regex.run(@single_die_regex, dice_str) ->
        die_list = List.insert_at(match, 2, "1")
        _parse(List.last(match), [Dice.ParsedDiceTerm.new(die_list) | result])
      
      match = Regex.run(@scalar_regex, dice_str) ->
        _parse(List.last(match), [Dice.ParsedScalarTerm.new(match) | result])

      match = Regex.run(@complex_regex, dice_str) ->
        [_, _, terms, _] = match
        parsed_inner_terms = _parse(terms)
        _parse(List.last(match), [Dice.ParsedComplexTerm.new(match, parsed_inner_terms) | result])

      true -> 
        Enum.reverse(result)
    end
  end
end