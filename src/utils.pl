/* get_cell(+Board, ?X, ?Y, ?Cell)
   Retrieves the content of a cell or the coordenates of one type of cell */
get_cell(Board, X, Y, Cell) :-
    nth1(X, Board, Row),
    nth1(Y, Row, Cell).

/* replace_in_row(+Row, +Col, +Val, -NewRow)
   Replaces the contents of a cell in a specific row */
replace_in_row([_|Rest], 1, Val, [Val|Rest]).
replace_in_row([X|Rest], Col, Val, [X|NewRest]) :-
    Col > 1,
    NextCol is Col - 1,
    replace_in_row(Rest, NextCol, Val, NewRest).

/* replace(+Board, +RowIndex, +Col, +Val, -NewBoard)
   Replaces the contents of a cell in the board */
replace([Row|Rest], 1, Col, Val, [NewRow|Rest]) :-
    replace_in_row(Row, Col, Val, NewRow).
replace([Row|Rest], RowIndex, Col, Val, [Row|NewRest]) :-
    RowIndex > 1,
    NextIndex is RowIndex - 1,
    replace(Rest, NextIndex, Col, Val, NewRest).

/* remove_checker(+Board, +X, +Y, -NewBoard)
   Removes a checker from the board */
remove_checker(Board, X, Y, NewBoard) :-
    size_board(N),
    Size is N + 1,
    X > 0, X < Size,   
    Y > 0, Y < Size,
    replace(Board, X, Y, empty, NewBoard).

/* place_checker(+Board, +X, +Y, +Checker, -NewBoard)
   Places a checker in the board */
place_checker(Board, X, Y, Checker, NewBoard) :-
    size_board(N),
    Size is N + 1,
    X > 0, X < Size,
    Y > 0, Y < Size,
    replace(Board, X, Y, Checker, NewBoard).

/* next_player(+Player, -NextPlayer)
   Gets the next player */
next_player(Player, NextPlayer) :-
    (Player = red -> NextPlayer = blue; NextPlayer = red).

/* valid_moves(+GameState, +Player, -ValidMoves)
   Retrieves all the valid moves available to a player */
valid_moves([Board, Player], Player, ValidMoves) :-
    findall((XCur, YCur, XNext, YNext), (
        get_cell(Board, XCur, YCur, Player),
        get_cell(Board, XNext, YNext, empty),
        count_adjacents(XCur, YCur, Board, Player, BeforeTotal, [], _BeforeVisited),
        move([Board, Player], (XCur, YCur, XNext, YNext), TemporaryGameState),
        [TemporaryBoard, _NewPlayer] = TemporaryGameState,
        count_adjacents(XNext, YNext, TemporaryBoard, Player, AfterTotal, [], _AfterVisited),
        AfterTotal > BeforeTotal
    ), ValidMoves).

/* read_move(-X, +Context)
   Reads the player's input regarding a move */
read_move(X, Context):-
    size_board(N),
    Size is N + 1,
    repeat,
    write(''),nl,
    atom_concat('INSERT THE ', Context, Print),
    write(Print), nl,
    read(X),
    ((X > 0 , X < Size) -> !; (write('WRONG OPTION, PLEASE ENTER ANOTHER ONE'), nl, fail)).

/* count_adjacents(+Position_row, +Position_column, +Board, +Color, -Total, +InitialVisited, -EndVisited)
   Counts the checkers adjacent to a specific checker */
count_adjacents(Position_row, Position_column, Board, Color, Total, InitialVisited, EndVisited) :-
    get_cell(Board, Position_row, Position_column, Color),
    append([[Position_row, Position_column]], InitialVisited, Temporary),
    size_board(N),
    ((Position_column < N, NewPosition_column is Position_column + 1, get_cell(Board, Position_row, NewPosition_column, Color), \+ memberchk([Position_row, NewPosition_column], InitialVisited)) -> 
        InitialVisitedRight = Temporary,
        count_adjacents(Position_row, NewPosition_column, Board, Color, TotalRight, InitialVisitedRight, EndVisitedRight);  
        TotalRight = 0, EndVisitedRight = Temporary),
      
    ((Position_column > 1, NewPosition_column1 is Position_column - 1, get_cell(Board, Position_row, NewPosition_column1, Color), \+ memberchk([Position_row, NewPosition_column1], EndVisitedRight)) ->
        InitialVisitedLeft = EndVisitedRight,
        count_adjacents(Position_row, NewPosition_column1, Board, Color, TotalLeft, InitialVisitedLeft, EndVisitedLeft);  
        TotalLeft = 0, EndVisitedLeft = EndVisitedRight),

    ((Position_row < N, NewPosition_row is Position_row + 1, get_cell(Board, NewPosition_row, Position_column, Color), \+ memberchk([NewPosition_row, Position_column], EndVisitedLeft)) ->
          InitialVisitedBelow = EndVisitedLeft,
          count_adjacents(NewPosition_row, Position_column, Board, Color, TotalBelow, InitialVisitedBelow, EndVisitedBelow);  
          TotalBelow = 0, EndVisitedBelow = EndVisitedLeft),
      
    ((Position_row > 1, NewPosition_row1 is Position_row - 1, get_cell(Board, NewPosition_row1, Position_column, Color), \+ memberchk([NewPosition_row1, Position_column], EndVisitedBelow)) ->
        InitialVisitedAbove = EndVisitedBelow,
        count_adjacents(NewPosition_row1, Position_column, Board, Color, TotalAbove, InitialVisitedAbove, EndVisitedAbove);  
        TotalAbove = 0, EndVisitedAbove = EndVisitedBelow),

    Total is TotalAbove + TotalBelow + TotalLeft + TotalRight + 1,
    EndVisited = EndVisitedAbove.

/* count_groups(+GameState, +Checkers, -Count)
   Counts the number of groups of a specific checker */
count_groups(_, [], 0).
count_groups([Board, Player], [(XCur, YCur)|Rest], Count):-
    count_adjacents(XCur, YCur, Board, Player, _Total, [], Visited),
    subtract(Rest, Visited, NewRest),
    count_groups([Board, Player], NewRest, NewCount),
    Count is NewCount + 1.

/* biggest_group(+GameState, +Checkers, +Count, -Max)
   Calculates the biggest group on the board of a specific checker */
biggest_group(_, [], Count, Count).
biggest_group([Board, Player], [(XCur, YCur)|Rest], Count, Max):-
    count_adjacents(XCur, YCur, Board, Player, Total, [], Visited),
    subtract(Rest, Visited, NewRest),
    (Total > Count ->
        biggest_group([Board, Player], NewRest, Total, Max);
        biggest_group([Board, Player], NewRest, Count, Max)
    ).

/* smallest_group(+GameState, +Checkers, +Count, -Max)
   Calculates the smallest group on the board of a specific checker */
smallest_group(_, [], Count, Count).
smallest_group([Board, Player], [(XCur, YCur)|Rest], Count, Min):-
    count_adjacents(XCur, YCur, Board, Player, Total, [], Visited),
    subtract(Rest, Visited, NewRest),
    (Total < Count ->
        smallest_group([Board, Player], NewRest, Total, Min);
        smallest_group([Board, Player], NewRest, Count, Min)
    ).

/* char_codes_to_chars(+Codes, -Chars)
   Transforms a list of codes in a list of chars */
char_codes_to_chars([], []).
char_codes_to_chars([Code | RestCodes], [Char | RestChars]) :-
    char_code(Char, Code),
    char_codes_to_chars(RestCodes, RestChars).
