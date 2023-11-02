/* initialize_board(+Structure) */
/* Initializes Bounce's board structure */
initialize_board([
        [empty, blue, red, blue, red, blue, red, empty],
        [blue, red, blue, red, blue, red, blue, red],
        [red, blue, red, blue, red, blue, red, blue],
        [blue, red, red, red, blue, red, blue, red],
        [red, blue, red, blue, red, blue, red, blue],
        [blue, red, blue, red, blue, red, blue, red],
        [red, blue, red, blue, red, blue, red, blue],
        [empty, red, blue, red, blue, red, blue, empty]
]).

/* display_board(+Board) */
/* Displays the game's board */
display_board(Board) :- 
        write('     1  2  3  4  5  6  7  8'), nl,
        write('    ________________________'), nl, nl,
        display_rows(Board, 1, 8),
        write('    ________________________'), nl, nl.

/* display_rows(+Board, +Line, ?Size) */
/* Displays every row in the board */
display_rows([], _, _).
display_rows([Row | Rest], Line, Size) :-
    format('~d | ', [Line]),
    display_row(Row),
    write(' |'),
    nl,
    NextLine is Line + 1,
    display_rows(Rest, NextLine, Size).

/* display_row(+Row) */
/* Displays every cell in a row */
display_row([]).
display_row([Cell | Rest]) :-
    display_cell(Cell),
    display_row(Rest).

/* display_cell(+Value) */
/* Displays a cell's contents */
display_cell(empty) :- write(' - ').
display_cell(blue) :- write(' X ').
display_cell(red) :- write(' O ').
display_cell(_).