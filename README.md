Dicer
=====

A dice roller expression evaluator written in Elixir!

Installation
============

Assuming you have Elixir (and Erlang) installed, simply download the source and run the following in the root project directory:

`iex -S mix`

From here, execute rolls like this:

`iex(1)> Dicer.roll "1+2+3"`

Details
=======

Dicer is an elixir application that lets you evaluate dice rolls with simple arithmetic operators. the operators supported are `+, -, /, *`, grouping via parentheses, and designating dice via <quantity>d<sides> format (Ex. 20d8 or D100).
