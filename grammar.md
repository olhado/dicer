Dicer Grammar
=============

digit = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"
number = [0-9]+
dice = ([0-9])*"d"[0-9]+
term = digit | dice
unary  = ("+" | "-")* term
multiplication = unary ("*" | "/" multiplication)*
addition = multiplication ("+" | "-" component)*
expression = addition 