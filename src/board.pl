/* initial_state(-Board)
   Bounce board's initial structure */
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

/*
initial_state([
        [blue, red, red, blue, blue, blue, blue, empty],
        [red, red, red, blue, blue, empty, empty, blue],
        [red, red, red, blue, blue, blue, blue, red],
        [red, red, red, red, blue, blue, blue, blue],
        [red, blue, red, red, blue, blue, red, blue],
        [red, red, red, red, red, red, red, blue],
        [red, red, red, blue, red, blue, red, blue],
        [blue, red, blue, blue, blue, blue, blue, empty]
]).*/ 

/* display_game(+GameState)
   Displays the current state of the game */
display_game([Board,_]) :- 
        write('     1  2  3  4  5  6  7  8'), nl,
        write('    ________________________'), nl, nl,
        display_rows(Board, 1),
        write('    ________________________'), nl, nl.

/* display_rows(+Board, +Line)
   Displays every row in the board */
display_rows([], _).
display_rows([Row | Rest], Line) :-
    format('~d | ', [Line]),
    display_row(Row),
    write(' |'),
    nl,
    NextLine is Line + 1,
    display_rows(Rest, NextLine).

/* display_row(+Row)
   Displays every cell in a row */
display_row([]).
display_row([Cell | Rest]) :-
    display_cell(Cell),
    display_row(Rest).

/* display_cell(+Value)
   Displays a cell's contents */
display_cell(empty) :- write(' - ').
display_cell(blue) :- write(' '), player_icon(blue, Icon), write(Icon), write(' ').
display_cell(red) :- write(' '), player_icon(red, Icon), write(Icon), write(' ').
display_cell(_).


/*if there is time*/

/*% Define the dimensions of the board.
% Define the initial state predicate.
initial_state(Size, Board) :-
    initial_board(Size, Size, Board).

% Define the initial board predicate.
initial_board(NRows, NCols, Board) :-
    initial_board(NRows, NCols, [], Board).

% Define a helper predicate to create the initial board row by row.
initial_board(0, _, Board, Board).
initial_board(N, NCols, PartialBoard, Board) :-
    length(PartialBoard, SizeBoard),
    ((SizeBoard = 0 ; N = 1) -> create_row_special(NCols, [], Row, red);
    (N mod 2 =:= 0 ->  
      create_row(NCols, Row, red);
      create_row(NCols, Row, blue))),
    N1 is N - 1,
    initial_board(N1, NCols, [Row | PartialBoard], Board).

% Define a helper predicate to create a single row of the board.
create_row(NCols, Row, Color) :-
    create_row(NCols, [], Row, Color).

create_row_special(0, Row, Row, _).
create_row_special(N, PartialRow, Row, Color) :-
    length(PartialRow, Size),
    next_color(Color, NextColor),
    N1 is N - 1,
    ((Size = 0; N = 1) -> 
    create_row_special(N1, [empty | PartialRow], Row, NextColor);
    create_row_special(N1, [Color | PartialRow], Row, NextColor)).

create_row(0, Row, Row, _).
create_row(N, PartialRow, Row, Color) :-
    next_color(Color, NextColor),
    N1 is N - 1,
    create_row(N1, [Color | PartialRow], Row, NextColor).

next_color(Color, NextColor):-
    (Color = red -> NextColor = blue; NextColor = red).*/