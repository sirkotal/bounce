:- consult('database').
:- consult('cpu').
:- consult('utils').

:- use_module(library(random)).
:- use_module(library(lists)).
:- use_module(library(sets)).

/* move(+GameState, +Move, -NewGameState)
   Execute the move chosen (move/remove a checker)*/
move([Board, Player], (XCur, YCur, -1, -1), NewGameState) :-
    remove_checker(Board, XCur, YCur, NewBoard),
    next_player(Player, NextPlayer),
    NewGameState = [NewBoard, NextPlayer].

move([Board, Player], (XCur, YCur, XNext, YNext), NewGameState) :-
    remove_checker(Board, XCur, YCur, TempBoard),
    place_checker(TempBoard, XNext, YNext, Player, NewBoard),
    next_player(Player, NextPlayer),
    NewGameState = [NewBoard, NextPlayer].

/* choose_move(+GameState, -Move)
   Verifies if the player is a Human and reads a valid move*/
choose_move([Board,Player], Move):-
    (bot(Player, Bot) ->
        choose_move([Board ,Player], Player, Bot, Move);   
        valid_moves([Board ,Player], Player, ValidMoves),
        length(ValidMoves, Moves),
        (Moves = 0 -> write(''), nl, write('THERE ARE NO AVAILABLE MOVES PLEASE CHOOSE A PIECE TO REMOVE'), nl,
            repeat,
            read_move(XCur, 'ROW'),
            read_move(YCur, 'COLUMN'),
            (get_cell(Board, XCur, YCur, Player) -> Move = (XCur,YCur,-1,-1) ; write('THAT MOVE IS NOT VALID!'), nl, fail);
            repeat,
            read_move(XCur, 'CURRENT ROW'),
            read_move(YCur, 'CURRENT COLUMN'),
            read_move(XNext, 'NEW ROW'),
            read_move(YNext, 'NEW COLUMN'),
            (memberchk((XCur, YCur, XNext, YNext), ValidMoves) -> Move = (XCur, YCur, XNext, YNext); write(''), nl, write('THAT MOVE IS NOT VALID!'), nl, fail))).

/* choose_move(+GameState, +Player, +Level, -Move)
   Makes a list of valid moves and chooses one randomly*/
choose_move([Board,Player], Player, 1, Move):-
    valid_moves([Board,Player], Player, ValidMoves),
    (ValidMoves \= [] ->
        bot_random_move(ValidMoves, Move);
        bot_random_remove(Board, Player, Move)
    ).

/* choose_move(+GameState, +Player, +Level, -Move)
   Makes a list of valid moves and chooses the one with less points based on an evaluation of the game state made on value(+GameState, +Player, -Value)*/
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

/* value(+GameState, +Player, -Value)
   Calculates the value of the current board*/
value([Board, _], Player, Value):-
    findall((X, Y), get_cell(Board, X, Y, Player), Checkers),
    length(Checkers, Size),
    count_groups([Board, Player], Checkers, Count),
    biggest_group([Board, Player], Checkers, 0, Max),
    smallest_group([Board, Player], Checkers, Size, Min),
    Value is 1000*Count + 10*(Size-Max) + Size-Min.

/*  game_over(+GameState, -Winner)
    Checks if the game has a winner */
game_over([Board, Player], Winner):- 
    next_player(Player, PreviousPlayer),
    get_cell(Board, X, Y, PreviousPlayer), !, 
    count_adjacents(X, Y, Board, PreviousPlayer, Total, [], _Visited),
    findall((XCur, YCur), get_cell(Board, XCur, YCur, PreviousPlayer), Checkers),
    length(Checkers, Count),
    (Total = Count -> Winner = PreviousPlayer; fail).

/*  congratulate(+Winner)
    Congratulates the winner */
congratulate(Winner):-
    write(''),nl,
    player_name(Winner, Name),
    atom_concat('CONGRATULATIONS ', Name, Print),
    write(Print),
    write(', YOU ARE THE WINNER!'), nl,
    write(''), nl,
    write('INSERT ANYTHING TO GO BACK TO MENU'), nl,
    read(_).

/*  print_player(+GameState)
    Prints the player that is currently playing */
print_player([_,Player]):-
    player_name(Player, Name),
    atom_concat('PLAYER TURN: ', Name, Print),
    write(Print),
    write(' ->'),
    display_cell(Player), nl, nl.