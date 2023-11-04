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

remove_checker(Board, X, Y, NewBoard) :-
    X > 0, X < 9,   
    Y > 0, Y < 9,
    replace(Board, X, Y, empty, NewBoard).

place_checker(Board, X, Y, Checker, NewBoard) :-
    X > 0, X < 9,
    Y > 0, Y < 9,
    replace(Board, X, Y, Checker, NewBoard).

next_player(Player, NextPlayer) :-
    (Player = red -> NextPlayer = blue; NextPlayer = red).

/*maybe not needed, only move*/
temp_move(Board, Checker, XCur, YCur, XNext, YNext, NewBoard):-
    remove_checker(Board, XCur, YCur, TempBoard),
    place_checker(TempBoard, XNext, YNext, Checker, NewBoard).

valid_moves([Board, CurPlayer], Player, ValidMoves) :-
    findall((XCur, YCur, XNext, YNext), (
        get_cell(Board, XCur, YCur, Player),
        get_cell(Board, XNext, YNext, empty),
        count_adjacents(XCur, YCur, Board, Player, BeforeTotal, [], _BeforeVisited),
        temp_move(Board, Player, XCur, YCur, XNext, YNext, TemporaryBoard),
        count_adjacents(XNext, YNext, TemporaryBoard, Player, AfterTotal, [], _AfterVisited),
        AfterTotal > BeforeTotal
    ), ValidMoves).

read_move(X, Context):-
    repeat,
    write(''),nl,
    atom_concat('INSERT THE ', Context, Print),
    write(Print), nl,
    read(X),
    ((X > 0 , X < 9) -> !; (write('WRONG OPTION, PLEASE ENTER ANOTHER ONE'), nl, fail)).

count_adjacents(Position_row, Position_column, Board, Color, Total, InitialVisited, EndVisited) :-
    get_cell(Board, Position_row, Position_column, Color),
    append([[Position_row, Position_column]], InitialVisited, Temporary),
    ((Position_column < 8, NewPosition_column is Position_column + 1, get_cell(Board, Position_row, NewPosition_column, Color), \+ memberchk([Position_row, NewPosition_column], InitialVisited)) -> 
        InitialVisitedRight = Temporary,
        count_adjacents(Position_row, NewPosition_column, Board, Color, TotalRight, InitialVisitedRight, EndVisitedRight);  
        TotalRight = 0, EndVisitedRight = Temporary),
      
    ((Position_column > 1, NewPosition_column1 is Position_column - 1, get_cell(Board, Position_row, NewPosition_column1, Color), \+ memberchk([Position_row, NewPosition_column1], EndVisitedRight)) ->
        InitialVisitedLeft = EndVisitedRight,
        count_adjacents(Position_row, NewPosition_column1, Board, Color, TotalLeft, InitialVisitedLeft, EndVisitedLeft);  
        TotalLeft = 0, EndVisitedLeft = EndVisitedRight),

    ((Position_row < 8, NewPosition_row is Position_row + 1, get_cell(Board, NewPosition_row, Position_column, Color), \+ memberchk([NewPosition_row, Position_column], EndVisitedLeft)) ->
          InitialVisitedBelow = EndVisitedLeft,
          count_adjacents(NewPosition_row, Position_column, Board, Color, TotalBelow, InitialVisitedBelow, EndVisitedBelow);  
          TotalBelow = 0, EndVisitedBelow = EndVisitedLeft),
      
    ((Position_row > 1, NewPosition_row1 is Position_row - 1, get_cell(Board, NewPosition_row1, Position_column, Color), \+ memberchk([NewPosition_row1, Position_column], EndVisitedBelow)) ->
        InitialVisitedAbove = EndVisitedBelow,
        count_adjacents(NewPosition_row1, Position_column, Board, Color, TotalAbove, InitialVisitedAbove, EndVisitedAbove);  
        TotalAbove = 0, EndVisitedAbove = EndVisitedBelow),

    Total is TotalAbove + TotalBelow + TotalLeft + TotalRight + 1,
    EndVisited = EndVisitedAbove.

count_groups(_, [], 0).
count_groups([Board, Player], [(XCur, YCur)|Rest], Count):-
    count_adjacents(XCur, YCur, Board, Player, Total, [], Visited),
    subtract(Rest, Visited, NewRest),
    count_groups([Board, Player], NewRest, NewCount),
    Count is NewCount + 1.

biggest_group(_, [], Count, Count).
biggest_group([Board, Player], [(XCur, YCur)|Rest], Count, Max):-
    count_adjacents(XCur, YCur, Board, Player, Total, [], Visited),
    subtract(Rest, Visited, NewRest),
    (Total > Count ->
        biggest_group([Board, Player], NewRest, Total, Max);
        biggest_group([Board, Player], NewRest, Count, Max)
    ).

smallest_group(_, [], Count, Count).
smallest_group([Board, Player], [(XCur, YCur)|Rest], Count, Max):-
    count_adjacents(XCur, YCur, Board, Player, Total, [], Visited),
    subtract(Rest, Visited, NewRest),
    (Total < Count ->
        smallest_group([Board, Player], NewRest, Total, Max);
        smallest_group([Board, Player], NewRest, Count, Max)
    ).
    

