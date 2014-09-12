defmodule Dicer.Validator do

  @valid_multiple_chars_regex ~r/^[0-9d\-\+\(]{1,1}[0-9d\-\+\*\/\(\)]*?[0-9\)]{1,1}$/i
  @valid_single_char_regex ~r/[0-9]/i
  @inner_term_regex ~r/\((.+?)\)[+-\/\*]{0,1}/i

  @invalid_chars_message "Invalid characters in input string!\n"
  @extra_closing_parens_message "A closing parenthesis does not match any opening parenthesis!\n"
  @extra_opening_parens_message "An opening parenthesis does not match any closing parenthesis!\n"
  @empty_parens_clauses_message "Empty clause in input!\n"

  def validate(dice_str) when is_binary(dice_str) do
      _validate({:ok, dice_str, ""})
  end

  defp _validate(validation_tuple) when is_tuple(validation_tuple) do
    validation_tuple
    |> _valid_chars
    |> _correct_num_of_parens
    |> _empty_parens_clauses
    |> _validate_inner_terms
  end

  defp _valid_chars(validation_tuple = {_, dice_str, _message}) do
    cond do
      String.length(dice_str) == 1 and Regex.match?(@valid_single_char_regex, dice_str)
        -> validation_tuple
      String.length(dice_str) > 1 and Regex.match?(@valid_multiple_chars_regex, dice_str)
        -> validation_tuple
      true
        -> {:error, dice_str, @invalid_chars_message}
    end
  end

  defp _correct_num_of_parens(validation_tuple = {:error, _, _}) do
    validation_tuple
  end

  defp _correct_num_of_parens(validation_tuple = {_, dice_str, _message}) do
    case _count_parens(dice_str, 0) do
        {:early_end, _} ->
          {:error, dice_str, @extra_closing_parens_message}
        {:full_scan, parens_count} when parens_count < 0 ->
          {:error, dice_str, @extra_closing_parens_message}
        {:full_scan, parens_count} when parens_count > 0 ->
          {:error, dice_str, @extra_opening_parens_message}
        _ -> validation_tuple
    end
  end

  defp _count_parens("", parens_count), do: {:full_scan, parens_count}
  defp _count_parens(_str, parens_count) when parens_count < 0, do: {:early_end, parens_count}
  defp _count_parens("(" <> str, parens_count), do: _count_parens(str, parens_count + 1)
  defp _count_parens(")" <> str, parens_count), do: _count_parens(str, parens_count - 1)
  defp _count_parens(str, parens_count), do: _count_parens(String.slice(str, 1..-1), parens_count)

  defp _empty_parens_clauses(validation_tuple = {:error, _, _}) do
    validation_tuple
  end

  defp _empty_parens_clauses(validation_tuple = {_, dice_str, _message}) do
    if Regex.match?(~r/\(\)/i, dice_str) do
      {:error, dice_str, @empty_parens_clauses_message}
    else
      validation_tuple
    end
  end

  defp _validate_inner_terms(validation_tuple = {:error, _, _}) do
    validation_tuple
  end

  defp _validate_inner_terms(validation_tuple = {:ok, dice_str, message}) do
    matches = Regex.scan(@inner_term_regex, dice_str)
    cond do
      length(matches) == 0 
        -> validation_tuple
      true
        ->
          IO.inspect validation_tuple
          IO.inspect matches
          List.flatten(for [_, capture] <- matches, do: _validate({:ok, capture, message}))
    end
  end
end