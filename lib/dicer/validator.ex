defmodule Dicer.Validator do
  def sanitize(input) when is_binary(input) do
    String.replace(input, ~r/\s/, "")
  end
end