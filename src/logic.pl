:- use_module(library(lists)).


/*maybe move to utils*/
print_array([]). % Base case, the list is empty, nothing to print.

print_array([Head | Tail]) :-
    write(Head), % Print the current element
    nl,          % Print a newline character to separate elements
    print_array(Tail). % Recursively print the rest of the list

get_element(Board, Row, Column, Element) :-
    nth1(Row, Board, RowList),
    nth1(Column, RowList, Element).

count_adjacents(Position_row, Position_column, Board, Color, Total, InitialVisited, EndVisited) :-
    append([[Position_row, Position_column]], InitialVisited, Temporary),
    (Position_column < 10 ->
      NewPosition_column is Position_column + 1,
      get_element(Board, Position_row, NewPosition_column, Element1),
      ((Element1 = Color, \+ memberchk([Position_row, NewPosition_column], InitialVisited)) -> 
      	NewInitialVisitedRight = Temporary,
        count_adjacents(Position_row, NewPosition_column, Board, Color, NewTotalRight, NewInitialVisitedRight, NewEndVisitedRight);  
      	NewTotalRight = 0, NewEndVisitedRight = Temporary)
    ),
    TotalRight = NewTotalRight,
    VisitedRight = NewEndVisitedRight,
    
    (Position_column > 1 ->
      NewPosition_column1 is Position_column - 1,
      get_element(Board, Position_row, NewPosition_column1, Element2),
      ((Element2 = Color, \+ memberchk([Position_row, NewPosition_column1], VisitedRight)) ->
        NewInitialVisitedLeft = VisitedRight,
      	count_adjacents(Position_row, NewPosition_column1, Board, Color, NewTotalLeft, NewInitialVisitedLeft, NewEndVisitedLeft);  
      	NewTotalLeft = 0, NewEndVisitedLeft = VisitedRight)
    ),
    TotalLeft = NewTotalLeft,
    VisitedLeft = NewEndVisitedLeft,

	(Position_row < 10 ->
      NewPosition_row is Position_row + 1,
      get_element(Board, NewPosition_row, Position_column, Element3),
      ((Element3 = Color, \+ memberchk([NewPosition_row, Position_column], VisitedLeft)) ->
        NewInitialVisitedBelow = VisitedLeft,
      	count_adjacents(NewPosition_row, Position_column, Board, Color, NewTotalBelow, NewInitialVisitedBelow, NewEndVisitedBelow);  
      	NewTotalBelow = 0, NewEndVisitedBelow = VisitedLeft)
    ),
    TotalBelow = NewTotalBelow,
    VisitedBelow = NewEndVisitedBelow,
    
    (Position_row > 1 ->
      NewPosition_row1 is Position_row - 1,
      get_element(Board, NewPosition_row1, Position_column, Element4),
      ((Element4 = Color, \+ memberchk([NewPosition_row1, Position_column], VisitedBelow)) ->
        NewInitialVisitedAbove = VisitedBelow,
      	count_adjacents(NewPosition_row1, Position_column, Board, Color, NewTotalAbove, NewInitialVisitedAbove, NewEndVisitedAbove);  
      	NewTotalAbove = 0, NewEndVisitedAbove = VisitedBelow)
    ),
    TotalAbove = NewTotalAbove,
    VisitedAbove = NewEndVisitedAbove,

    Total is TotalAbove + TotalBelow + TotalLeft + TotalRight + 1,
    
	EndVisited = VisitedAbove.

initialize_board([
        [border, border, border, border, border, border, border, border, border, border],
        [border, empty, blue, blue, blue, blue, blue, blue, blue, border],
        [border, blue, blue, blue, red, blue, red, blue, red, border],
        [border, red, blue, red, blue, red, blue, red, blue, border],
        [border, blue, red, blue, red, blue, red, blue, red, border],
        [border, red, blue, red, blue, red, blue, red, blue, border],
        [border, blue, red, blue, red, blue, red, blue, red, border],
        [border, red, blue, red, blue, red, blue, red, blue, border],
        [border, empty, red, blue, red, blue, red, blue, empty, border],
        [border, border, border, border, border, border, border, border, border, border]
]).


