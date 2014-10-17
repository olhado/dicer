defmodule Dicer.Validator do
    @invalid_operator_sequences_regex ~r/[\/\+\*-]{1}[\/\+\*-]+/i
    @operator_at_end_regex ~r/[\/\+\*\-]$/i
    @plus_times_divide_at_start_regex ~r/^[\/\*]/i

    @validation_regexes [{@invalid_operator_sequences_regex, "Improper operator format (Ex. 1--1)!"},
                          {@operator_at_end_regex, "Trailing operator(s) on input!"},
                          {@plus_times_divide_at_start_regex, "Invalid operator(s) at beginning of input!"}]

  def validate(input) when is_binary(input) do
    input
    |> _validate
  end

  def validate(_input) do
    {:error, ["Not a string!"]}
  end

  defp _validate(input) do
    validation_results =
    for {regex, error_message} <- @validation_regexes, Regex.match?(regex, input) do
      error_message
    end

    case Enum.empty? validation_results do
      false ->
        {:error, validation_results}
      true -> 
        {:ok, input}
    end
  end
end