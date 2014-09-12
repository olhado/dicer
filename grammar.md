Dicer Grammar
=============

digit = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"
sign = "+" | "-"
number = [sign] {digit}
factor = number | "(" expression ")"
term = factor [{("^" | "d") factor}]
component = term [{("*" | "/") term}]
expression = component [{("+" | "-") component}]