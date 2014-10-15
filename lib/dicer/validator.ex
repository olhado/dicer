defmodule Dicer.Validator do
  def sanitize(input) when is_binary(input) do
    {:ok, String.replace(input, ~r/\s/, "")}
  end

  def sanitize(_input) do
    {:error, "Not a string!"}
  end
end