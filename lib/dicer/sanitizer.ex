defmodule Dicer.Sanitizer do
  def sanitize(input) do
    sanitized_input = String.replace(input, ~r/\s/, "")
    {:ok, sanitized_input}
  end
end