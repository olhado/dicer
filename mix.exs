defmodule Dicer.Mixfile do
  use Mix.Project

  def project do
    [app: :dicer,
     version: "0.8.0",
     elixir: "~> 1.0.0",
     deps: deps,
     escript: escript,
     description: description,
     package: package,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:sfmt, :logger]]
  end

  def escript do
    [main_module: Dicer.CLI]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [{:sfmt, "~> 0.10.1"},
      {:ex_doc, "~> 0.6", only: :dev}]
  end

  defp description do
    """
    Elixir library to calculate dice rolls.
    """
  end

  defp package do
     [contributors: ["Michael Chmielewski"],
     licenses: ["MIT License"],
     links: %{"GitHub" => "https://github.com/olhado/dicer"}]
  end
end
