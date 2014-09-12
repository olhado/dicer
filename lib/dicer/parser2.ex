defmodule Dicer.Parser2 do
  def parse(input) when is_binary(input) do

    {result, new_input} = _expression(input, 0)
    cond do
      Dicer.Lexer.process_next_token(new_input) == %Dicer.Tokens.End{}
        -> IO.puts result
      true
        -> raise "Expected End Token!"
    end
  end

  defp _expression(input, acc) do
    component1 = _component(input, acc)

    token = Dicer.Lexer.process_next_token(input)


  end

  defp _component(input, acc) do
    num1 = _number(input, acc)
  end

  defp _number(input, acc) do
    {value, new_input} = _number(input, Dicer.Lexer.process_next_token(input))
    {acc + value, new_input}
  end

  defp _number(input, num = %Dicer.Tokens.Num{}, acc) do
    # Get num value
    num_str = (Regex.run(Dicer.Tokens.Num.get_regex, input)
    |> List.first)

    # Get rest of input string
    new_input = (String.split(input, num_str, parts: 2) 
    |> List.last)

    {num.value, new_input}
  end
end