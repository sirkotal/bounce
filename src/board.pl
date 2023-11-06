
/* initial_state(+Size, -GameState)
   Bounce board's initial structure */
initial_state(Size, [Board,Player]) :-
    starting_player(Player),
    initial_board(Size, Size, TempBoard),
    replace(TempBoard, 1, 1, empty, TempBoard1),
    replace(TempBoard1, 1, Size, empty, TempBoard2),
    replace(TempBoard2, Size, 1, empty, TempBoard3),
    replace(TempBoard3, Size, Size, empty, Board).

/* initial_board(+NRows, +NCols, -Board)
   Initializes the board */
% Define the initial board predicate.
initial_board(NRows, NCols, Board) :-
    initial_board(NRows, NCols, [], Board).

initial_board(0, _, Board, Board).
initial_board(N, NCols, PartialBoard, Board) :-
    (N mod 2 =:= 0 ->  
      create_row(NCols, Row, red);
      create_row(NCols, Row, blue)),
    N1 is N - 1,
    initial_board(N1, NCols, [Row | PartialBoard], Board).

/* create_row(+NCols, -Row, +Color)
   Creates one row to the board */
create_row(NCols, Row, Color) :-
    create_row(NCols, [], Row, Color).

create_row(0, Row, Row, _).
create_row(N, PartialRow, Row, Color) :-
    next_color(Color, NextColor),
    N1 is N - 1,
    create_row(N1, [Color | PartialRow], Row, NextColor).

/* next_color(+Color, -NextColor)
   Switches the color */
next_color(Color, NextColor):-
    (Color = red -> NextColor = blue; NextColor = red).

/* display_game(+GameState)
   Displays the current state of the game */
display_game([Board,_]) :- 
        size_board(N),
        write('\33\[2J'),
        write(''), nl,
        write('      '), header(N, 1), nl,
        N1 is N*3,
        write('     '), line(N1, 1),
    	 nl, nl,
        display_rows(Board, 1),
        write('     '), line(N1, 1), nl, nl.

/* display_rows(+Board, +Line)
   Displays every row in the board */
display_rows([], _).
display_rows([Row | Rest], Line) :-
    (Line < 10 -> format('~d  | ', [Line]) ; format('~d | ', [Line])),
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

/* display_row(+Number,+Current)
   Displays the header of the board */
header(N, N) :- write(N).
header(N, Cur) :-
    write(Cur), 
    (Cur < 10 -> write('  ') ; write(' ')),
    NewCur is Cur + 1,
    header(N, NewCur).
    
/* line(+Number,+Current)
   Displays a line */
line(N, N) :- write('_').
line(N, Cur) :-
    write('_'),
    NewCur is Cur + 1,
    line(N, NewCur).

/* display_cell(+Value)
   Displays a cell's contents */
display_cell(empty) :- write(' - ').
display_cell(blue) :- write(' '), player_icon(blue, Icon), write(Icon), write(' ').
display_cell(red) :- write(' '), player_icon(red, Icon), write(Icon), write(' ').
display_cell(_).
