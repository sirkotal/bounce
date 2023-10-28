count_adjacents(Position_row, Position_column, Board, Color, Sum, HelperSum) :- 
    write('right'), nl,
    (Position_row < 9 -> 
        NewPosition_row is Position_row + 1, 
        get_element(Board, NewPosition_row, Position_column, Element),
        (Element = Color -> 
        	UpdatedHelperSum is HelperSum + 1,
    		count_adjacents(NewPosition_row, Position_column, Board, Color, Sum, UpdatedHelperSum),
            SumRight is HelperSum
    	; true)
    ;true),

    /*left*/
    write('left'), nl,
    (Position_row > 2 -> 
    	NewPosition_row1 is Position_row - 1, 
    	get_element(Board, NewPosition_row1, Position_column, Element1),
        (Element1 = Color -> 
        	UpdatedHelperSum2 is HelperSum + 1,
    		count_adjacents(NewPosition_row1, Position_column, Board, Color, SumRight, UpdatedHelperSum2),
    		SumLeft is HelperSum
    	; true)
    ;true),

    /*above*/
    write('above'), nl,
    (Position_column > 2 -> 
    	NewPosition_column is Position_column - 1, 
      	get_element(Board, Position_row, NewPosition_column, Element2),
      	(Element2 = Color -> 
      		UpdatedHelperSum3 is HelperSum + 1,
        	count_adjacents(Position_row, NewPosition_column, Board, Color, SumLeft, UpdatedHelperSum3),
        	SumAbove is HelperSum
    	; true)
    ;true),

    /*below*/
    write('below'), nl,
    (Position_column < 9 -> 
    	NewPosition_column1 is Position_column + 1, 
        get_element(Board, Position_row, NewPosition_column1, Element3),
        (Element3 = Color -> 
        	UpdatedHelperSum4 is HelperSum + 1,
    		count_adjacents(Position_row, NewPosition_column1, Board, Color, SumAbove, UpdatedHelperSum4),
    		SumBelow is HelperSum
    	; true)
    ;true),

    % Sum up the counts in all directions
    Sum is SumBelow + SumAbove + SumLeft + SumRight. 


:- use_module(library(lists)).

/*maybe move to utils*/
:- use_module(library(lists)).

/*maybe move to utils*/
get_element(Board, Row, Column, Element) :-
    nth1(Row, Board, RowList),
    nth1(Column, RowList, Element).

get_element(_, _, 1, _) :- write('here').
get_element(_, Row, 10, _) :- write('here').
get_element(_, 10, _, _) :- write('here').
get_element(_, 1, _, _) :- write('here').


count_adjacents(_, 10, _, _, 0) :- write('here').
count_adjacents(_, 1, _, _, 0) :- write('here').
count_adjacents(1, _, _, _, 0) :- write('here').
count_adjacents(10, _, _, _, 0) :- write('here').

count_adjacents(Position_row, Position_column, Board, Color, Total) :-
    write(Position_row), nl,
    write(Position_column), nl,
    get_element(Board, Position_row, Position_column, Element),
    Position_column < 10,
    NewPosition_column is Position_column + 1,
    get_element(Board, Position_row, NewPosition_column, Element1),
	(Element1 = 'blue' ->  count_adjacents(Position_row, NewPosition_column, Board, Color, NewTotal);  NewTotal is 0),
    (Element = 'blue' ->  TotalRight is NewTotal + 1;  TotalRight is NewTotal),
    
    Position_column > 1,
    NewPosition_column1 is Position_column - 1,
    get_element(Board, Position_row, NewPosition_column1, Element2),
	(Element2 = 'blue' ->  count_adjacents(Position_row, NewPosition_column1, Board, Color, NewTotal);  NewTotal is 0),
    (Element = 'blue' ->  TotalLeft is NewTotal + 1;  TotalLeft is NewTotal),

	Position_row < 10,
    NewPosition_row is Position_row + 1,
    get_element(Board, NewPosition_row, Position_column, Element3),
	(Element3 = 'blue' ->  count_adjacents(NewPosition_row, Position_column, Board, Color, NewTotal);  NewTotal is 0),
    (Element = 'blue' ->  TotalBelow is NewTotal + 1;  TotalBelow is NewTotal),

	Position_column > 1,
    NewPosition_column1 is Position_column + 1,
    get_element(Board, Position_row, NewPosition_column1, Element4),
	(Element4 = 'blue' ->  count_adjacents(Position_row, NewPosition_column1, Board, Color, NewTotal);  NewTotal is 0),
    (Element = 'blue' ->  TotalAbove is NewTotal + 1;  TotalAbove = NewTotal),
    
    Total is TotalAbove + TotalBelow + TotalLeft + TotalRight,
    write(Total), nl.
    
initialize_board([
        [border, border, border, border, border, border, border, border, border, border],
        [border, empty, blue, blue, blue, blue, blue, blue, blue, border],
        [border, blue, red, blue, red, blue, red, blue, red, border],
        [border, red, blue, red, blue, red, blue, red, blue, border],
        [border, blue, red, blue, red, blue, red, blue, red, border],
        [border, red, blue, red, blue, red, blue, red, blue, border],
        [border, blue, red, blue, red, blue, red, blue, red, border],
        [border, red, blue, red, blue, red, blue, red, blue, border],
        [border, empty, red, blue, red, blue, red, blue, empty, border],
        [border, border, border, border, border, border, border, border, border, border]
]).