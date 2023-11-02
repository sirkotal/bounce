:- use_module(library(lists)).

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

bot_random_move(Board, ValidMoves) :-
    length(ValidMoves, N),
    random(0, N, Index),
    nth0(Index, ValidMoves, (XCur, YCur, XNext, YNext)),
    valid_move(Board, XCur, YCur, XNext, YNext, Checker, NewBoard),
    Board = NewBoard.

bot_greedy_move([], Checker, Best, Best, Max, _).
bot_greedy_move([(XCur, YCur, XNext, YNext) | Rest], Checker, (BestXCur, BestYCur, BestXNext, BestYNext), Best, Max, Board) :-
    checker_move(Board, XCur, YCur, XNext, YNext, Checker, TemporaryBoard),
    count_adjacents(XCur, YCur, Board, Checker, BeforeTotal, [], _BeforeVisited),
    count_adjacents(XNext, YNext, TemporaryBoard, Checker, AfterTotal, [], _AfterVisited),
    (AfterTotal > BeforeTotal, AfterTotal > Max ->
        bot_greedy_move(Rest, Checker, (XCur, YCur, XNext, YNext), Best, AfterTotal, Board);
        bot_greedy_move(Rest, Checker, (BestXCur, BestYCur, BestXNext, BestYNext), Best, Max, Board)
    ).

print_valid_moves([]).
print_valid_moves([(XCur, YCur, XNext, YNext) | Rest]) :-
    write('XCur: '), write(XCur), write(', '),
    write('YCur: '), write(YCur), write(', '),
    write('XNext: '), write(XNext), write(', '),
    write('YNext: '), write(YNext), nl,
    print_valid_moves(Rest).

bot_move(Board, Diff, Checker, NewBoard) :-
    find_all_valid_moves(Board, Checker, ValidMoves),
    ((Diff = 1) -> 
    bot_random_move(Board, ValidMoves);
    /*print_valid_moves(ValidMoves),*/
    write('here'),
    bot_greedy_move(ValidMoves, Checker, (0,0,0,0), Best, 0, Board),
    (XCur, YCur, XNext, YNext) = Best,
    checker_move(Board, XCur, YCur, XNext, YNext, Checker, NewBoard),
    write('leaving'), nl).
