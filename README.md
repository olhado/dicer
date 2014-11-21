Dicer
=====

A dice roller expression evaluator written in Elixir!

Installation
============

Pre-requisites
--------------

* Erlang 17 or greater
* Elixir 1.0.1
* git (to clone the repository)

Creating a command line binary
------------------------------

`mix escript.build`

From here, execute rolls like this:

`$ dicer "1+2+3"`

Running in interactive shell
----------------------------

`iex -S mix`

From here, execute rolls like this:

`iex(1)> Dicer.roll "1+2+3"`

Adding as a mix dependency
--------------------------

In your mix.exs file:

```
  def application do
    [mod: {MyApp, []},
     applications: [:dicer]]
  end
```

and this:

```
  defp deps do
    [{:dicer, "0.4.0"}]
  end
```

Details
=======

Dicer is an elixir application that lets you evaluate dice rolls with simple arithmetic operators. 

* The operators supported are `+, -, /, *`.
* Grouping is via parentheses
* Polyhedral dice are designated using the `<quantity>d<sides>` format (Ex. 20d8 or D100).
* Fudge/Fate dice are designated using the `<quantity>dF` format (Ex. 42dF)
* You can ask Dicer to take the top or bottom X rolls via the `^<quantity>` (take top) and `v<quantity>` (take bottom) symbols (Ex. 10d100^5 [take top 5 results from 10 rolls of a 100-sided die])

Why?
====

Because it was a fun, somewhat non-trivial way to work in Elixir.

Thanks
======

Thanks to [Lukasz Wrobel](http://lukaszwrobel.pl/) for his [short series on parsing](http://lukaszwrobel.pl/blog/math-parser-part-1-introduction). Part 3 was my template for my code, even if it took me way too long to translate the loops into recursive function calls!
