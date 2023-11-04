initial_state([
        [empty, blue, red, blue, red, blue, red, empty],
        [blue, red, blue, red, blue, red, blue, red],
        [red, blue, red, blue, red, blue, red, blue],
        [blue, red, blue, red, blue, red, blue, red],
        [red, blue, red, blue, red, blue, red, blue],
        [blue, red, blue, red, blue, red, blue, red],
        [red, blue, red, blue, red, blue, red, blue],
        [empty, red, blue, red, blue, red, blue, empty]
]).

/*initial_state([
        [blue, red, red, blue, blue, blue, blue, empty],
        [red, red, red, blue, blue, empty, empty, blue],
        [red, red, red, blue, blue, blue, blue, red],
        [red, red, red, red, blue, blue, blue, blue],
        [red, blue, red, red, blue, blue, red, blue],
        [red, red, red, red, red, red, red, blue],
        [red, red, red, blue, red, blue, red, blue],
        [blue, red, blue, blue, blue, blue, blue, empty]
]).*/

display_game([Board,_]) :- 
        write('     1  2  3  4  5  6  7  8'), nl,
        write('    ________________________'), nl, nl,
        display_rows(Board, 1, 10),
        write('    ________________________'), nl, nl.

display_rows([], _, _).
display_rows([Row | Rest], Line, Size) :-
    format('~d | ', [Line]),
    display_row(Row),
    write(' |'),
    nl,
    NextLine is Line + 1,
    display_rows(Rest, NextLine, Size).

display_row([]).
display_row([Cell | Rest]) :-
    display_cell(Cell),
    display_row(Rest).

display_cell(empty) :- write(' - ').
display_cell(blue) :- write(' X ').
display_cell(red) :- write(' O ').
display_cell(_).