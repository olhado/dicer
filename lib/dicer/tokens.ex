defmodule Dicer.Tokens do
  defmodule Plus do
    @representation ~r/\A\+/
    defstruct function: &(&1 + &2)

    def get_regex() do
      @representation
    end
  end

  defmodule Minus do
    @representation ~r/\A-/
    defstruct function: &(&1 - &2)

    def get_regex() do
      @representation
    end
  end

  defmodule Multiply do
    @representation ~r/\A\*/
    defstruct function: &(&1 * &2)

    def get_regex() do
      @representation
    end
  end

  defmodule Divide do
    @representation ~r/\A\//
    defstruct function: &(&1 / &2)

    def get_regex() do
      @representation
    end
  end

  defmodule LeftParenthesis do
    @representation ~r/\A\(/
    defstruct value: "("

    def get_regex() do
      @representation
    end
  end

  defmodule RightParenthesis do
    @representation ~r/\A\)/
    defstruct value: ")"

    def get_regex() do
      @representation
    end
  end

  defmodule Dice do
    @representation ~r/\A(\d*)[dD](\d+)/
    defstruct quantity: 0, sides: 1, values: []

    def get_regex() do
      @representation
    end
  end

  defmodule Num do
    @representation ~r/\A(\d*)(\.)*(\d+)/
    defstruct value: nil

    def convert_to_float(input = %Num{}) do
      {num_val, _} = Float.parse(input.value)

      Float.round(num_val,4)
    end

    def get_regex() do
      @representation
    end
  end

  defmodule End do
    @representation ~r/\A\z/
    defstruct value: ""

    def get_regex() do
      @representation
    end
  end
end