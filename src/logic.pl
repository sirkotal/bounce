:- use_module(library(lists)).

count_adjacents(Position_row, Position_column, Board, Color, Total, InitialVisited, EndVisited) :-
    append([[Position_row, Position_column]], InitialVisited, Temporary),
    (Position_column < 10 ->
      NewPosition_column is Position_column + 1,
      get_cell(Board, Position_row, NewPosition_column, ElementRight),
      ((ElementRight = Color, \+ memberchk([Position_row, NewPosition_column], InitialVisited)) -> 
        InitialVisitedRight = Temporary,
        count_adjacents(Position_row, NewPosition_column, Board, Color, TotalRight, InitialVisitedRight, EndVisitedRight);  
        TotalRight = 0, EndVisitedRight = Temporary)
    ),
      
    (Position_column > 1 ->
      NewPosition_column1 is Position_column - 1,
      get_cell(Board, Position_row, NewPosition_column1, ElementLeft),
      ((ElementLeft = Color, \+ memberchk([Position_row, NewPosition_column1], EndVisitedRight)) ->
        InitialVisitedLeft = EndVisitedRight,
        count_adjacents(Position_row, NewPosition_column1, Board, Color, TotalLeft, InitialVisitedLeft, EndVisitedLeft);  
        TotalLeft = 0, EndVisitedLeft = EndVisitedRight)
    ),

    (Position_row < 10 ->
        NewPosition_row is Position_row + 1,
        get_cell(Board, NewPosition_row, Position_column, ElementBelow),
        ((ElementBelow = Color, \+ memberchk([NewPosition_row, Position_column], EndVisitedLeft)) ->
          InitialVisitedBelow = EndVisitedLeft,
          count_adjacents(NewPosition_row, Position_column, Board, Color, TotalBelow, InitialVisitedBelow, EndVisitedBelow);  
          TotalBelow = 0, EndVisitedBelow = EndVisitedLeft)
    ),
      
    (Position_row > 1 ->
      NewPosition_row1 is Position_row - 1,
      get_cell(Board, NewPosition_row1, Position_column, ElementAbove),
      ((ElementAbove = Color, \+ memberchk([NewPosition_row1, Position_column], EndVisitedBelow)) ->
        InitialVisitedAbove = EndVisitedBelow,
        count_adjacents(NewPosition_row1, Position_column, Board, Color, TotalAbove, InitialVisitedAbove, EndVisitedAbove);  
        TotalAbove = 0, EndVisitedAbove = EndVisitedBelow)
    ),

    Total is TotalAbove + TotalBelow + TotalLeft + TotalRight + 1,
      
    EndVisited = EndVisitedAbove.

bot_random_move(Board, ValidMoves) :-
    length(ValidMoves, N),
    random(0, N, Index),
    nth0(Index, ValidMoves, (XCur, YCur, XNext, YNext)),
    valid_move(Board, XCur, YCur, XNext, YNext, Checker, NewBoard),
    Board = NewBoard.


bot_move(Diff, Checker) :-
    ((Diff = 1) -> 
    find_all_valid_moves(Board, Checker, ValidMoves),
    bot_random_move(Board, ValidMoves);
    find_all_valid_moves(Board, Checker, ValidMoves)).
