initialize_board([
        [border, border, border, border, border, border, border, border, border, border],
        [border, red, red, red, red, red, red, red, blue, border],
        [border, red, blue, blue, red, blue, blue, blue, blue, border],
        [border, blue, blue, blue, blue, blue, blue, blue, blue, border],
        [border, blue, blue, blue, blue, blue, red, blue, red, border],
        [border, blue, blue, red, blue, red, red, red, red, border],
        [border, blue, red, red, red, red, red, red, red, border],
        [border, blue, blue, red, red, red, red, red, empty, border],
        [border, blue, blue, red, red, empty, blue, empty, empty, border],
        [border, border, border, border, border, border, border, border, border, border]
]).

display_board(GameBoard) :- display_rows(GameBoard, 1, 10).

display_rows([], _, _).
display_rows([Row | Rest], Line, Size) :-
    format('~d | ', [Line]),
    display_row(Row),
    nl,
    NextLine is Line + 1,
    display_rows(Rest, NextLine, Size).

display_row([]).
display_row([Cell | Rest]) :-
    display_cell(Cell),
    display_row(Rest).

display_cell(empty) :- write(' - ').
display_cell(blue) :- write(' B ').
display_cell(red) :- write(' R ').
display_cell(border) :- write(' # ').
display_cell(_).