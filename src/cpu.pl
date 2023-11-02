:- use_module(library(lists)).
:- use_module(library(random)).

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
    random_select((XPos, YPos), Checkers, RemainingCheckers),
    remove_checker(Board, XPos, YPos, NewBoard).

bot_move(Board, Diff, Checker, NewBoard) :-
    find_all_valid_moves(Board, Checker, ValidMoves),
    ((Diff = 1, ValidMoves \= []) -> 
    bot_random_move(Board, ValidMoves, NewBoard);
    bot_random_remove(Board, Checker, NewBoard)),

    ((Diff = 2, ValidMoves \= []) -> 
    /* print_valid_moves(ValidMoves), */
    bot_greedy_move(ValidMoves, Checker, (0,0,0,0), Best, 0, Board),
    (XCur, YCur, XNext, YNext) = Best,
    checker_move(Board, XCur, YCur, XNext, YNext, Checker, NewBoard);
    ).