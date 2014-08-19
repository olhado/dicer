defmodule Dice do
  defmodule ParsedScalarTerm do
    defstruct operand: nil, value: 0
  
    def new([_, operand, value, rest]) do
      op = Dice.Parser.determine_operand(operand)
      %ParsedScalarTerm{operand: op, value: value}
    end
  end

  defmodule ParsedDiceTerm, do: defstruct operand: nil, quantity: 0, sides: 10
  defmodule ParsedComplexTerm, do: defstruct operand: nil, terms: []

  defmodule Parser do
    @valid_chars_regex ~r/^[0-9d\-\+\(]{1,1}[0-9d\-\+\*\/\(\)]*?[0-9\)]{1,1}$/i
    
    @multiple_dice_regex ~r/^([\+\-\*\/]?)(\d+?)d(\d+)(.*)/i
    @single_die_regex ~r/^([\+\-\*\/]?)d(\d+)(.*)/i
    @scalar_regex ~r/^([\+\-\*\/]?)(\d+)(.*)/i
    @complex_regex ~r/^([\+\-\*\/]?)[\(]{1,1}([0-9d\-\*\+\/\(\)]+)[\)]{1,1}([\+\-\*\/]?.*)/i

    def parse(dice_str) when is_binary(dice_str) and dice_str != "" do
        validation_result = _strip_spaces(dice_str)
                                        |> _validate

        case validation_result do
          {:ok, valid_str, []} ->
            _strip_spaces(valid_str)
              |> _parse

          {:error, _invalid_str, reason} ->
            IO.puts reason

          _ ->
            {:error, ["Unknown error!!!\n"]}
        end
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
      parens_count_result = _count_parens(dice_str, 0)
 
      case parens_count_result do
          {:early_end, _} ->
            {:error, dice_str, ["Closing parenthesis does not match any opening parenthesis!\n" | messages]}

          {:full_scan, parens_count} when parens_count != 0 ->
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
      match = Regex.match?(~r/\(\)/i, dice_str)

      if match do
        {:error, dice_str, ["Empty clause in input!\n" | messages]}
      else
        validation_tuple
      end
    end

    defp _parse(dice_str, result \\ []) # Function head for defaults
    defp _parse(dice_str, result) do
      cond do
        match = Regex.run(@multiple_dice_regex, dice_str) ->
          [_, operand, quantity, sides, rest] = match
          {quant, _} = Integer.parse(quantity)
          {num_of_sides, _} = Integer.parse(sides)
          op = determine_operand(operand)
          _parse(rest, [%ParsedDiceTerm{operand: op, quantity: quant,  sides: num_of_sides} | result])
        
        match = Regex.run(@single_die_regex, dice_str) ->
          [_, operand, sides, rest] = match
          {num_of_sides, _} = Integer.parse(sides)
          op = determine_operand(operand)
          _parse(rest, [%ParsedDiceTerm{operand: op, quantity: 1,  sides: num_of_sides} | result])
        
        match = Regex.run(@scalar_regex, dice_str) ->
          [_, operand, value, rest] = match
          _parse(rest, [ParsedScalarTerm.new(match) | result])

        match = Regex.run(@complex_regex, dice_str) ->
          [_, operand, terms, rest] = match
          op = determine_operand(operand)
          _parse(rest, [%ParsedComplexTerm{operand: op, terms: _parse(terms)} | result])

        true -> 
          Enum.reverse(result)
        end
    end

    def determine_operand("") do
      "+"
    end

    def determine_operand(operand) when is_binary(operand) and byte_size(operand) == 1 do
      operand
    end
  end
end