defmodule Dice.Validator do

  @valid_chars_regex ~r/^[0-9d\-\+\(]{1,1}[0-9d\-\+\*\/\(\)]*?[0-9\)]{1,1}$/i
  @valid_single_char_regex ~r/[0-9]/i

  def validate(dice_str) do
    {:ok, dice_str, []}
    |> _valid_chars
    |> _correct_num_of_parens
    |> _empty_parens_clauses
  end

  defp _valid_chars(validation_tuple = {_, dice_str, messages}) do
    cond do
      String.length(dice_str) == 1
        -> valid_str = Regex.match?(@valid_single_char_regex, dice_str)

      true
        -> valid_str = Regex.match?(@valid_chars_regex, dice_str)
    end

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
          {:error, dice_str, ["A closing parenthesis does not match any opening parenthesis!\n" | messages]}

        {:full_scan, parens_count} when parens_count > 0 ->
          {:error, dice_str, ["An opening parenthesis does not match any closing parenthesis!\n" | messages]}

        _ -> validation_tuple
    end
  end

  defp _count_parens("", parens_count), do: {:full_scan, parens_count}
  defp _count_parens(_str, parens_count) when parens_count < 0, do: {:early_end, parens_count}
  defp _count_parens("(" <> str, parens_count), do: _count_parens(str, parens_count + 1)
  defp _count_parens(")" <> str, parens_count), do: _count_parens(str, parens_count - 1)
  defp _count_parens(str, parens_count), do: _count_parens(String.slice(str, 1..-1), parens_count)

  defp _empty_parens_clauses(validation_tuple = {_, dice_str, messages}) do
    # TODO: CHECK FOR VALID CLAUSE CONTENTS
    if Regex.match?(~r/\(\)/i, dice_str) do
      {:error, dice_str, ["Empty clause in input!\n" | messages]}
    else
      validation_tuple
    end
  end
end