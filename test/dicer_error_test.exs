defmodule DicerErrorTest do
  use ExUnit.Case

  ### Testing Error Cases
  test "unbalanced left parentheses" do
    assert Dicer.roll("(123)+(") == {:error, "Missing closing parenthesis!"}
  end

  test "unbalanced right parentheses" do
    assert Dicer.roll("(123)+)") == {:error, "Missing opening parenthesis!"}
  end

  test "gibberish" do
    assert Dicer.roll("a") == {:error, "Invalid Token!"}
  end

  test "more gibberish" do
    assert Dicer.roll("abcdef%") == {:error, "Invalid Token!"}
  end

  test "some valid with gibberish" do
    assert Dicer.roll("(1*6)/30d4*abcdef%") == {:error, "Invalid Token!"}
  end

  test "bad math" do
    assert Dicer.roll("1/0") == {:error, "bad argument in arithmetic expression"}
  end

  test "more bad math" do
    assert Dicer.roll("0/0") == {:error, "bad argument in arithmetic expression"}
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

  test "trailing operator (multiple)" do
    assert Dicer.roll("1-1-/+*") == {:error, ["Improper operator format (Ex. 1--1)!", "Trailing operator(s) on input!"]}
  end

  test "multiple operators in a row (same operator)" do
    assert Dicer.roll("1--1") == {:error, ["Improper operator format (Ex. 1--1)!"]}
  end

  test "multiple operators in a row (different operators)" do
    assert Dicer.roll("1+-1") == {:error, ["Improper operator format (Ex. 1--1)!"]}
  end

  test "multiple operators in a row (different operators, lots of operators)" do
    assert Dicer.roll("1+/*-1") == {:error, ["Improper operator format (Ex. 1--1)!"]}
  end

  test "multiple validation errors" do
    assert Dicer.roll("1+/*-1-+") == {:error, ["Improper operator format (Ex. 1--1)!", "Trailing operator(s) on input!"]}
  end
end
