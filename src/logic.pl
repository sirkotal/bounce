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

remove_checker(Board, X, Y, NewBoard) :-
    X > 0, X < 9,   
    Y > 0, Y < 9,
    replace(Board, X, Y, empty, NewBoard).

place_checker(Board, X, Y, Checker, NewBoard) :-
    X > 0, X < 9,
    Y > 0, Y < 9,
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
    ((X > 0 , X < 9) -> !; (write('WRONG OPTION, PLEASE ENTER ANOTHER ONE'), nl, fail)).

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