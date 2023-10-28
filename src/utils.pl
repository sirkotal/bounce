get_cell(Board, X, Y, Cell) :-
    nth1(X, Board, Row),
    nth1(Y, Row, Cell).

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
    X > 1, X =< 9,   
    Y > 1, Y =< 9,
    replace(Board, X, Y, empty, NewBoard).

place_checker(Board, X, Y, Checker, NewBoard) :-
    X > 1, X =< 9,
    Y > 1, Y =< 9,
    replace(Board, X, Y, Checker, NewBoard).

checker_move(Board, XCur, YCur, XNext, YNext, Checker, NewBoard) :-
    remove_checker(Board, XCur, YCur, TempBoard),
    place_checker(TempBoard, XNext, YNext, Checker, NewBoard).

valid_move(Board, XCur, YCur, XNext, YNext, Checker, NewBoard) :- 
    ((get_cell(Board, XCur, YCur, Checker), get_cell(Board, XNext, YNext, empty) -> checker_move(Board, XCur, YCur, XNext, YNext, Checker, NewBoard);
    NewBoard = Board, write('That move is not valid!'), nl)).

find_all_valid_moves(Board, Checker, ValidMoves) :-
    findall((XCur, YCur, XNext, YNext), (
        between(1, 10, XCur),
        between(1, 10, YCur),
        get_cell(Board, XCur, YCur, Color),
        /* TODO */
        member((XNext, YNext), EmptyCells),
        valid_move(Board, XCur, YCur, XNext, YNext, Checker, _)
    ), ValidMoves).