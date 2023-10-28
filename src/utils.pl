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
    X > 0, X =< 10,   
    Y > 0, Y =< 10,
    replace(Board, X, Y, empty, NewBoard).

place_checker(Board, X, Y, Checker, NewBoard) :-
    X > 0, X =< 10,
    Y > 0, Y =< 10,
    replace(Board, X, Y, Checker, NewBoard).

checker_move(Board, XCur, YCur, XNext, YNext, Checker, NewBoard) :-
    remove_checker(Board, XCur, YCur, TempBoard),
    place_checker(TempBoard, XNext, YNext, Checker, NewBoard).

valid_move(Board, XCur, YCur, XNext, YNext, Checker, NewBoard) :- 
    ((get_cell(Board, XCur, YCur, Checker), get_cell(Board, XNext, YNext, empty) -> checker_move(Board, XCur, YCur, XNext, YNext, Checker, NewBoard);
    NewBoard = Board)).