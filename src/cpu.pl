:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(between)).

bot_random_move(Board, ValidMoves, Move) :-
    length(ValidMoves, N),
    random(0, N, Index),
    nth0(Index, ValidMoves, (XCur, YCur, XNext, YNext)),
    Move = (XCur, YCur, XNext, YNext).

bot_random_remove(Board, Player, Move) :-
    findall((X, Y), get_cell(Board, X, Y, Player), Checkers),
    random_member((XPos, YPos), Checkers),
    Move = (XPos, YPos, -1, -1), !.

bot_find_min_group([], Checker, Worst, Worst, Min, _).
bot_find_min_group([(XCur, YCur) | Rest], Checker, (XRemove, YRemove), Worst, Min, Board) :-
    count_adjacents(XCur, YCur, Board, Checker, Total, [], Visited),
    subtract(Rest, Visited, NewRest),
    (Total < Min ->
        bot_find_min_group(NewRest, Checker, (XCur, YCur), Worst, Total, Board);
        bot_find_min_group(NewRest, Checker, (XRemove, YRemove), Worst, Min, Board)
    ).

bot_greedy_remove(Board, Player, Move) :-
    write('what'),
    count_checkers(Board, Player, Min),
    findall((X, Y), get_cell(Board, X, Y, Player), Checkers),
    bot_find_min_group(Checkers, Player, (0,0), Worst, Min, Board),
    (XCur, YCur) = Worst,
    Move = (XCur, YCur, -1, -1).