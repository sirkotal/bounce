:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(between)).

bot_random_move(Board, ValidMoves, NewBoard) :-
    length(ValidMoves, N),
    random(0, N, Index),
    nth0(Index, ValidMoves, (XCur, YCur, XNext, YNext)),
    valid_move(Board, XCur, YCur, XNext, YNext, Checker, NewBoard).

bot_greedy_move([], Checker, Best, Best, Max, _).
bot_greedy_move([(XCur, YCur, XNext, YNext) | Rest], Checker, (BestXCur, BestYCur, BestXNext, BestYNext), Best, Max, Board) :-
    checker_move(Board, XCur, YCur, XNext, YNext, Checker, TemporaryBoard),
    count_adjacents(XCur, YCur, Board, Checker, BeforeTotal, [], _BeforeVisited),
    count_adjacents(XNext, YNext, TemporaryBoard, Checker, AfterTotal, [], _AfterVisited),
    (AfterTotal > BeforeTotal, AfterTotal > Max ->
        bot_greedy_move(Rest, Checker, (XCur, YCur, XNext, YNext), Best, AfterTotal, Board);
        bot_greedy_move(Rest, Checker, (BestXCur, BestYCur, BestXNext, BestYNext), Best, Max, Board)
    ).

bot_random_remove(Board, Checker, NewBoard) :-
    findall((X, Y), get_cell(Board, X, Y, Checker), Checkers),
    random_member((XPos, YPos), Checkers),
    remove_checker(Board, XPos, YPos, NewBoard), !.

bot_find_min_group([], Checker, Worst, Worst, Min, _).
bot_find_min_group([(XCur, YCur) | Rest], Checker, (XRemove, YRemove), Worst, Min, Board) :-
    count_adjacents(XCur, YCur, Board, Checker, Total, [], _Visited),
    (Total < Min ->
        bot_find_min_group(Rest, Checker, (XCur, YCur), Worst, Total, Board);
        bot_find_min_group(Rest, Checker, (XRemove, YRemove), Worst, Min, Board)
    ).

bot_greedy_remove(Board, Checker, NewBoard) :-
    count_checkers(Board, Checker, Min),
    find_all_checkers(Board, Checker, Checkers),
    bot_find_min_group(Checkers, Checker, (0,0), Worst, Min, Board),
    (XPos, YPos) = Worst,
    remove_checker(Board, XPos, YPos, NewBoard).

bot_move(Board, Diff, Checker, NewBoard) :-
    find_all_valid_moves(Board, Checker, ValidMoves),

    (Diff = 1 ->
    (ValidMoves \= [] ->
        bot_random_move(Board, ValidMoves, NewBoard);
        bot_random_remove(Board, Checker, NewBoard)
    );
    
    Diff = 2 ->
    (ValidMoves \= [] ->
        bot_greedy_move(ValidMoves, Checker, (0,0,0,0), Best, 0, Board),
        (XCur, YCur, XNext, YNext) = Best,
        checker_move(Board, XCur, YCur, XNext, YNext, Checker, NewBoard);
        bot_greedy_remove(Board, Checker, NewBoard)
    )).