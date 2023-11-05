:- use_module(library(lists)).
:- use_module(library(random)).

/* bot_random_move(+Board, +ValidMoves, -Move)
   Allows the level 1 CPU player to select a valid move */
bot_random_move(Board, ValidMoves, Move) :-
    length(ValidMoves, N),
    random(0, N, Index),
    nth0(Index, ValidMoves, (XCur, YCur, XNext, YNext)),
    Move = (XCur, YCur, XNext, YNext).

/* bot_random_remove(+Board, +Player, -Move)
   Allows the level 1 CPU player to select a checker to remove from the board */
bot_random_remove(Board, Player, Move) :-
    findall((X, Y), get_cell(Board, X, Y, Player), Checkers),
    random_member((XPos, YPos), Checkers),
    Move = (XPos, YPos, -1, -1), !.
