defmodule Dicer.Tokens do
  defmodule Plus do
    @representation ~r/\A\+/
    defstruct value: "+"

    def get_regex() do
      @representation
    end
  end

  defmodule Minus do
    @representation ~r/\A-/
    defstruct value: "-"

    def get_regex() do
      @representation
    end
  end

  defmodule Multiply do
    @representation ~r/\A\*/
    defstruct value: "*"

    def get_regex() do
      @representation
    end
  end

  defmodule Divide do
    @representation ~r/\A\//
    defstruct value: "/"

    def get_regex() do
      @representation
    end
  end

  defmodule Exponent do
    @representation ~r/\A\^/
    defstruct value: "^"

    def get_regex() do
      @representation
    end
  end

  defmodule Dice do
    @representation ~r/\A[dD]/
    defstruct value: "d"

    def get_regex() do
      @representation
    end
  end

  defmodule Num do
    @representation ~r/\A(\d+(\.\d+)?)/
    defstruct value: nil

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

  defmodule End do
    @representation ~r/\A\z/
    defstruct value: ""

    def get_regex() do
      @representation
    end
  end
end