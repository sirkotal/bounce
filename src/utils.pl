get_cell(Board, X, Y, Cell) :-
    nth1(X, Board, Row),
    nth1(Y, Row, Cell).


/* maybe change this to databas*/
count_checkers(Board, Checker, Count) :-
    count_checkers(Board, Checker, 1, 1, 0, Count).

count_checkers([], _, _, _, Count, Count).
count_checkers([Row|Rest], Checker, X, Y, Temp, Count) :-
    count_checkers_in_row(Row, Checker, X, Y, RowCount),
    XNext is X + 1,
    TempCount is Temp + RowCount,
    count_checkers(Rest, Checker, XNext, Y, TempCount, Count).

count_checkers_in_row([], _, _, _, 0).
count_checkers_in_row([Checker|Rest], Checker, X, Y, RowCount) :-
    !,
    YNext is Y + 1,
    count_checkers_in_row(Rest, Checker, X, YNext, TempRowCount),
    RowCount is 1 + TempRowCount.
count_checkers_in_row([_|Rest], Checker, X, Y, RowCount) :-
    YNext is Y + 1,
    count_checkers_in_row(Rest, Checker, X, YNext, RowCount).

replace_in_row([_|Rest], 1, Val, [Val|Rest]).
replace_in_row([X|Rest], Col, Val, [X|NewRest]) :-
    Col > 1,
    NextCol is Col - 1,
    replace_in_row(Rest, NextCol, Val, NewRest).

replace([Row|Rest], 1, Col, Val, [NewRow|Rest]) :-
    replace_in_row(Row, Col, Val, NewRow).
replace([Row|Rest], RowIndex, Col, Val, [Row|NewRest]) :-
    RowIndex > 1,
    NextIndex is RowIndex - 1,
    replace(Rest, NextIndex, Col, Val, NewRest).

remove_checker(Board, X, Y, NewBoard) :-
    X > 1, X < 10,   
    Y > 1, Y < 10,
    replace(Board, X, Y, empty, NewBoard).

place_checker(Board, X, Y, Checker, NewBoard) :-
    X > 1, X < 10,
    Y > 1, Y < 10,
    replace(Board, X, Y, Checker, NewBoard).

checker_move(Board, XCur, YCur, XNext, YNext, Checker, NewBoard) :-
    remove_checker(Board, XCur, YCur, TempBoard),
    place_checker(TempBoard, XNext, YNext, Checker, NewBoard).

/* check later (assign Checker to variable) */
valid_move(Board, XCur, YCur, XNext, YNext, Checker, NewBoard) :- 
    ((get_cell(Board, XCur, YCur, Checker), get_cell(Board, XNext, YNext, empty)) -> 
        checker_move(Board, XCur, YCur, XNext, YNext, Checker, TemporaryBoard),
        count_adjacents(XCur, YCur, Board, Checker, BeforeTotal, [], _BeforeVisited),
        count_adjacents(XNext, YNext, TemporaryBoard, Checker, AfterTotal, [], _AfterVisited),
        (AfterTotal > BeforeTotal -> NewBoard = TemporaryBoard; NewBoard = Board, write('That move is not valid!'), nl, fail);
    NewBoard = Board, write('That move is not valid!'), nl, fail).

find_all_valid_moves(Board, Checker, ValidMoves) :-
    findall((XCur, YCur, XNext, YNext), (
        get_cell(Board, XCur, YCur, Checker),
        get_cell(Board, XNext, YNext, empty),
        count_adjacents(XCur, YCur, Board, Checker, BeforeTotal, [], _BeforeVisited),
        checker_move(Board, XCur, YCur, XNext, YNext, Checker, TemporaryBoard),
        count_adjacents(XNext, YNext, TemporaryBoard, Checker, AfterTotal, [], _AfterVisited),
        AfterTotal > BeforeTotal
    ), ValidMoves).

read_move(X, Context):-
    repeat,
    write(''),nl,
    atom_concat('INSERT THE ', Context, Print),
    write(Print), nl,
    read(X),
    ((X > 1 , X < 10) -> !; (write('WRONG OPTION, PLEASE ENTER ANOTHER ONE'), nl, fail)).

choose_move(Board, Player, NewBoard):-
    repeat,
    find_all_valid_moves(Board, Player, ValidMoves),
    length(ValidMoves, Moves),
    (Moves = 0 -> write(''), nl, write('THERE ARE NO AVAILABLE MOVES PLEASE CHOOSE A PIECE TO REMOVE'), nl,
        read_move(XCur, 'ROW'),
        read_move(YCur, 'COLUMN'),
        remove_checker(Board, XCur, YCur, NewBoard);
        read_move(XCur, 'CURRENT ROW'),
        read_move(YCur, 'CURRENT COLUMN'),
        read_move(XNext, 'NEW ROW'),
        read_move(YNext, 'NEW COLUMN'),
        valid_move(Board, XCur, YCur, XNext, YNext, Player, NewBoard)).

next_player(Player, NextPlayer) :-
    (Player = red -> NextPlayer = blue; NextPlayer = red).

game_over(Board, Player, Winner):- 
    next_player(Player, PreviousPlayer),
    get_cell(Board, X, Y, PreviousPlayer), !, 
    count_adjacents(X, Y, Board, PreviousPlayer, Total, [], _Visited),
    count_checkers(Board, PreviousPlayer, Count),
    (Total = Count -> Winner = PreviousPlayer; fail).

congratulate(Winner):-
    write(''),nl,
    atom_concat('OH MY F*CKING GOD congratulation for winning this game ', Winner, Print),
    write(Print),
    write(', imagine playing this tho...').
    