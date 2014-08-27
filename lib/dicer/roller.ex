defmodule Dicer.Roller do
  import Dicer.Terms

  def roll(terms \\ [], result \\ %{value: 0, terms: []})
  def roll([], result), do: IO.inspect result
  
  def roll([head = %Dicer.Terms.Scalar{} | tail], result) do
    IO.puts head.operand <> head.value
    roll(tail, %{result | value: (result[:value] + Integer.parse(head.operand <> head.value))})
  end


end