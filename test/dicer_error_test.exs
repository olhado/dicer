defmodule DicerErrorTest do
  use ExUnit.Case

  ### Testing Error Cases
  test "unbalanced left parentheses" do
    assert Dicer.roll("(123)+(") == {:error, ["Missing closing parenthesis!"]}
  end

  test "unbalanced right parentheses" do
    assert Dicer.roll("(123)+)") == {:error, ["Missing opening parenthesis!"]}
  end

  test "nested bad parentheses (closing)" do
    assert Dicer.roll("(((((((((()))))))))") == {:error, ["Unbalanced parentheses!"]}
  end

  test "nested bad parentheses (opening)" do
    assert Dicer.roll("((((())))))") == {:error, ["Unbalanced parentheses!"]}
  end

  test "nested bad parentheses (closing, with inner value)" do
    assert Dicer.roll("((((((((((0)))))))))") == {:error, ["Missing closing parenthesis!"]}
  end

  #TODO: Fix this error message
  test "nested bad parentheses (opening, with inner value)" do
    assert Dicer.roll("(((((0))))))") == {:error, ["Unexpected error in parser!"]}
  end

  test "gibberish" do
    assert Dicer.roll("a") == {:error, ["Input has unrecognized characters!"]}
  end

  test "more gibberish" do
    assert Dicer.roll("abcdef%") == {:error, ["Input has unrecognized characters!"]}
  end

  test "some valid with gibberish" do
    assert Dicer.roll("(1*6)/30d4*abcdef%") == {:error, ["Input has unrecognized characters!"]}
  end

  test "bad math" do
    assert Dicer.roll("1/0") == {:error, ["bad argument in arithmetic expression"]}
  end

  test "more bad math" do
    assert Dicer.roll("0/0") == {:error, ["bad argument in arithmetic expression"]}
  end

  test "trailing operator (-)" do
    assert Dicer.roll("1-1-") == {:error, ["Trailing operator(s) on input!"]}
  end

  test "trailing operator (+)" do
    assert Dicer.roll("1-1+") == {:error, ["Trailing operator(s) on input!"]}
  end

  test "trailing operator (*)" do
    assert Dicer.roll("1-1*") == {:error, ["Trailing operator(s) on input!"]}
  end

  test "trailing operator (/)" do
    assert Dicer.roll("1-1/") == {:error, ["Trailing operator(s) on input!"]}
  end

  test "trailing operator (^)" do
    assert Dicer.roll("1-1/^") == {:error, ["Input has unrecognized characters!"]}
  end

  test "trailing operator (v)" do
    assert Dicer.roll("1-1v") == {:error, ["Input has unrecognized characters!"]}
  end

  # test "trailing operator (multiple)" do
  #   assert Dicer.roll("1-1-/+*") == {:error, ["Improper operator format (Ex. 1--1)!", "Trailing operator(s) on input!"]}
  # end

  test "multiple operators in a row (same operator)" do
    assert Dicer.roll("1--1") == {:error, ["Improper operator format (Ex. 1--1)!"]}
  end

  test "multiple operators in a row (different operators)" do
    assert Dicer.roll("1+-1") == {:error, ["Improper operator format (Ex. 1--1)!"]}
  end

  test "multiple operators in a row (different operators, lots of operators)" do
    assert Dicer.roll("1+/*-1") == {:error, ["Improper operator format (Ex. 1--1)!"]}
  end

  test "bad operator at start" do
    assert Dicer.roll("/1") == {:error, ["Invalid operator(s) at beginning of input!"]}
  end

  # test "multiple validation errors" do
  #   assert Dicer.roll("1+/*-1-+") == {:error, ["Improper operator format (Ex. 1--1)!", "Trailing operator(s) on input!"]}
  # end

  # test "all validation errors" do
  #   assert Dicer.roll("/1+/*-1-+") == {:error, ["Improper operator format (Ex. 1--1)!", "Trailing operator(s) on input!", "Invalid operator(s) at beginning of input!"]}
  # end
end