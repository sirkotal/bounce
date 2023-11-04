:- use_module(library(lists)).
:- use_module(library(sets)).

move([Board, Player], (XCur, YCur, -1, -1), NewGameState) :-
    remove_checker(Board, XCur, YCur, NewBoard),
    next_player(Player, NextPlayer),
    NewGameState = [NewBoard, NextPlayer].

move([Board, Player], (XCur, YCur, XNext, YNext), NewGameState) :-
    remove_checker(Board, XCur, YCur, TempBoard),
    place_checker(TempBoard, XNext, YNext, Player, NewBoard),
    next_player(Player, NextPlayer),
    NewGameState = [NewBoard, NextPlayer].

choose_move([Board,Player], Move):-
    (bot(Player, Bot) ->
        choose_move([Board ,Player], Player, Bot, Move);   
        valid_moves([Board ,Player], Player, ValidMoves),
        length(ValidMoves, Moves),
        (Moves = 0 -> write(''), nl, write('THERE ARE NO AVAILABLE MOVES PLEASE CHOOSE A PIECE TO REMOVE'), nl,
            repeat,
            read_move(XCur, 'ROW'),
            read_move(YCur, 'COLUMN'),
            get_cell(Board, XCur, YCur, Player),
            Move = (XCur,YCur,-1,-1);
            repeat,
            read_move(XCur, 'CURRENT ROW'),
            read_move(YCur, 'CURRENT COLUMN'),
            read_move(XNext, 'NEW ROW'),
            read_move(YNext, 'NEW COLUMN'),
            (memberchk((XCur, YCur, XNext, YNext), ValidMoves) -> Move = (XCur, YCur, XNext, YNext); write(''), nl, write('THAT MOVE IS NOT VALID!'), nl, fail))).

choose_move([Board,Player], Player, 1, Move):-
    write('here'),
    valid_moves([Board,Player], Player, ValidMoves),
    (ValidMoves \= [] ->
        bot_random_move(Board, ValidMoves, Move);
        bot_random_remove(Board, Player, Move)
    ).

choose_move([Board,Player], Player, 2, Move):-
    valid_moves([Board,Player], Player, ValidMoves),
    (ValidMoves \= [] ->
        findall(Value-Mv, (
            member(Mv, ValidMoves),
            move([Board,Player], Mv, NewState),
            value(NewState, Player, Value)
        ), Moves),
        keysort(Moves, [Test-Move | Rest]);
        findall(Value-(XCur, YCur, -1, -1), (
            get_cell(Board, XCur, YCur, Player),
            move([Board,Player], (XCur, YCur, -1, -1), NewState),
            value(NewState, Player, Value)
        ), Moves),
        keysort(Moves, [Test-Move | Rest])
    ).

value([Board, OtherPlayer], Player, Value):-
    findall((X, Y), get_cell(Board, X, Y, Player), Checkers),
    length(Checkers, Size),
    count_groups([Board, Player], Checkers, Count),
    biggest_group([Board, Player], Checkers, 0, Max),
    smallest_group([Board, Player], Checkers, Size, Min),
    /*maybe add more conditions*/
    Value is Count + Size-Max + Size-Min.

game_over([Board, Player], Winner):- 
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

print_player([_,Player]):-
    atom_concat('PLAYER TURN: ', Player, Print),
    write(Print),
    write(' ->'),
    display_cell(Player), nl.