:- use_module(library(lists)).
:- use_module(library(random)).


:- consult('src/board').
:- consult('src/utils').
:- consult('src/logic').
:- consult('src/database').
:- consult('src/menu').

game_cycle(Board, Player):-
    game_over(Board, Player, Winner), !,
    congratulate(Winner).

game_cycle(Board, Player):-
    write(''),nl,
    atom_concat('PLAYER TURN: ', Player, Print),
    write(Print), nl,
    choose_move(Board, Player, NextBoard),
    next_player(Player, NextPlayer),
    display_board(NextBoard), !,    
    game_cycle(NextBoard, NextPlayer).

play:-
    show_menu,
    initialize_board(Board),
    display_board(Board),
    count_checkers(Board, red, RedCount), write('Number of red checkers: '), write(RedCount), nl,
    choose_difficulty(X),
    game_cycle(Board, red).
