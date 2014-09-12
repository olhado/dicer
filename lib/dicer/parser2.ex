defmodule Dicer.Parser2 do
  def parse(input) when is_binary(input) do

    result = _expression(input, 0)
    cond do
      Dicer.Lexer.process_next_token(input) == %Dicer.Tokens.End{}
        -> IO.puts result
      true
        -> raise "Expected End Token!"
    end
  end

  defp _expression(input, acc) do
    component1 = _component(input)
    
  end

  defp _component(input) do
    num1 = _number(input)
  end

  defp _number(input, num = %Dicer.Tokens.Num{}) do
    num_str = (Regex.run(Dicer.Tokens.Num.get_regex, input)
    |> List.first)
    a =  String.split(input, num_str, parts: 2) 
    IO.inspect List.last(a)
    new_input = (String.split(input, num_str, parts: 2) 
    |> List.last)

    {num.value, new_input}
  end

  defp _number(input) do
    _number(input, Dicer.Lexer.process_next_token(input))

  end
end