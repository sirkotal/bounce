:- dynamic color/2.
color(red, '\033[91m').
color(blue, '\033[94m').
color(reset, '\033[0m').

colored_checker(Color, Symbol) :-
    color(Color, ColorCode),
    write(ColorCode),
    write(Symbol), 
    color(reset, ResetCode),
    write(ResetCode).

show_checker(empty) :- write('   ').
show_checker(red) :- colored_checker(red, ' ● ').
show_checker(blue) :- colored_checker(blue, ' ● ').