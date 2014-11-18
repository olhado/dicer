defmodule DicerTest do
  use ExUnit.Case

  test "blank input" do
    assert Dicer.roll("") == {:ok, [%Dicer.Tokens.End{value: ""}], 0.0}
  end

  test "single integer" do
    assert Dicer.roll("1") == {:ok, [%Dicer.Tokens.Num{value: "1"}, %Dicer.Tokens.End{value: ""}], 1.0}
  end

  test "negative number" do
    assert Dicer.roll("-1") == {:ok, [%Dicer.Tokens.Minus{function: &:erlang.-/2}, %Dicer.Tokens.Num{value: "1"}, %Dicer.Tokens.End{value: ""}], -1.0}
  end

  test "positive number" do
    assert Dicer.roll("+1") == {:ok, [%Dicer.Tokens.Plus{function: &:erlang.+/2}, %Dicer.Tokens.Num{value: "1"}, %Dicer.Tokens.End{value: ""}], 1.0}
  end

  test "single float" do
    assert Dicer.roll("1.23456789") == {:ok, [%Dicer.Tokens.Num{value: "1.23456789"}, %Dicer.Tokens.End{value: ""}], 1.2346}
  end

  test "rolling dice" do
    assert Dicer.roll("10d1") == {:ok, [%Dicer.Tokens.Dice{quantity: 10, sides: 1, counted_values: [1, 1, 1, 1, 1, 1, 1, 1, 1, 1], rejected_values: [], raw_rolls: [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]}, %Dicer.Tokens.End{value: ""}], 10.0}
  end

  test "rolling fudge dice" do
    {:ok, [result | tail], _total} = Dicer.roll("df")
    assert result == -1 || 0 || 1
    assert tail == [%Dicer.Tokens.End{}]
  end

  test "rolling dice, take top 2" do
    {:ok,  [%Dicer.Tokens.Dice{quantity: 4, sides: 6, counted_values: c_values, rejected_values: r_values, raw_rolls: _ }, %Dicer.Tokens.TakeTop{}, %Dicer.Tokens.End{value: ""}], _ } = Dicer.roll("4d6^2")
    assert length(c_values) == 2
    assert length(r_values) == 2

    assert Enum.sum(c_values) >= Enum.sum(r_values)
  end

  test "rolling dice, take bottom 2" do
    {:ok,  [%Dicer.Tokens.Dice{quantity: 4, sides: 6, counted_values: c_values, rejected_values: r_values}, %Dicer.Tokens.End{value: ""}], _ } = Dicer.roll("4d6v2")
    assert length(c_values) == 2
    assert length(r_values) == 2

    assert Enum.sum(c_values) <= Enum.sum(r_values)
  end

  test "rolling one die, no quantity" do
    assert Dicer.roll("d1") == {:ok, [%Dicer.Tokens.Dice{quantity: 1, sides: 1, counted_values: [1], rejected_values: [], raw_rolls: [1]}, %Dicer.Tokens.End{value: ""}], 1.0}
  end

  test "addition" do
    assert Dicer.roll("1+0.5") == {:ok, [%Dicer.Tokens.Num{value: "1"}, %Dicer.Tokens.Plus{function: &:erlang.+/2}, %Dicer.Tokens.Num{value: "0.5"}, %Dicer.Tokens.End{value: ""}], 1.5}
  end

  test "subtraction" do
    assert Dicer.roll("1-0.5") == {:ok, [%Dicer.Tokens.Num{value: "1"}, %Dicer.Tokens.Minus{function: &:erlang.-/2}, %Dicer.Tokens.Num{value: "0.5"}, %Dicer.Tokens.End{value: ""}], 0.5}
  end

  test "multiplication" do
    assert Dicer.roll("1*0.5") == {:ok, [%Dicer.Tokens.Num{value: "1"}, %Dicer.Tokens.Multiply{function: &:erlang.*/2}, %Dicer.Tokens.Num{value: "0.5"}, %Dicer.Tokens.End{value: ""}], 0.5}
  end

  test "division" do
    assert Dicer.roll("1/0.5") == {:ok, [%Dicer.Tokens.Num{value: "1"}, %Dicer.Tokens.Divide{function: &:erlang.//2}, %Dicer.Tokens.Num{value: "0.5"}, %Dicer.Tokens.End{value: ""}], 2.0}
  end

  test "parentheses" do
    assert Dicer.roll("(1.2222)") == {:ok, [%Dicer.Tokens.LeftParenthesis{value: "("}, %Dicer.Tokens.Num{value: "1.2222"}, %Dicer.Tokens.RightParenthesis{value: ")"}, %Dicer.Tokens.End{value: ""}], 1.2222}
  end

  test "dice roll results stay in expected range" do
    for _ <- 1..100 do
      {:ok, _input, value} = Dicer.roll("d40")
      # IO.puts value # TODO: Replace with Logger!
      assert value >= 1 and value <= 40
    end
  end

  test "nested parentheses" do
    assert Dicer.roll("1-(6-((12)+400))") == {:ok, [%Dicer.Tokens.Num{value: "1"}, %Dicer.Tokens.Minus{function: &:erlang.-/2}, %Dicer.Tokens.LeftParenthesis{value: "("}, %Dicer.Tokens.Num{value: "6"}, %Dicer.Tokens.Minus{function: &:erlang.-/2},
             %Dicer.Tokens.LeftParenthesis{value: "("}, %Dicer.Tokens.LeftParenthesis{value: "("}, %Dicer.Tokens.Num{value: "12"}, %Dicer.Tokens.RightParenthesis{value: ")"}, %Dicer.Tokens.Plus{function: &:erlang.+/2},
             %Dicer.Tokens.Num{value: "400"}, %Dicer.Tokens.RightParenthesis{value: ")"}, %Dicer.Tokens.RightParenthesis{value: ")"}, %Dicer.Tokens.End{value: ""}], 407.0}
  end

  test "all operators together" do
    assert Dicer.roll("1000-350/2*3+(100/(20*5))-575+10d1") == {:ok, [%Dicer.Tokens.Num{value: "1000"}, %Dicer.Tokens.Minus{function: &:erlang.-/2}, %Dicer.Tokens.Num{value: "350"}, %Dicer.Tokens.Divide{function: &:erlang.//2}, %Dicer.Tokens.Num{value: "2"},
             %Dicer.Tokens.Multiply{function: &:erlang.*/2}, %Dicer.Tokens.Num{value: "3"}, %Dicer.Tokens.Plus{function: &:erlang.+/2}, %Dicer.Tokens.LeftParenthesis{value: "("}, %Dicer.Tokens.Num{value: "100"},
             %Dicer.Tokens.Divide{function: &:erlang.//2}, %Dicer.Tokens.LeftParenthesis{value: "("}, %Dicer.Tokens.Num{value: "20"}, %Dicer.Tokens.Multiply{function: &:erlang.*/2}, %Dicer.Tokens.Num{value: "5"},
             %Dicer.Tokens.RightParenthesis{value: ")"}, %Dicer.Tokens.RightParenthesis{value: ")"}, %Dicer.Tokens.Minus{function: &:erlang.-/2}, %Dicer.Tokens.Num{value: "575"}, %Dicer.Tokens.Plus{function: &:erlang.+/2},
             %Dicer.Tokens.Dice{quantity: 10, sides: 1, counted_values: [1, 1, 1, 1, 1, 1, 1, 1, 1, 1], rejected_values: [], raw_rolls: [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]}, %Dicer.Tokens.End{value: ""}], -89.0}
  end
end