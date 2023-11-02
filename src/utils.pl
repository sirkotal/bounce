get_cell(Board, X, Y, Cell) :-
    nth1(X, Board, Row),
    nth1(Y, Row, Cell).

print_valid_moves([]).
print_valid_moves([(XCur, YCur, XNext, YNext) | Rest]) :-
    write('XCur: '), write(XCur), write(', '),
    write('YCur: '), write(YCur), write(', '),
    write('XNext: '), write(XNext), write(', '),
    write('YNext: '), write(YNext), nl,
    print_valid_moves(Rest).

print_array([]). 
print_array([Head | Tail]) :-
    write(Head), 
    nl,          
    print_array(Tail).

/* maybe change this to the database */
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