:- use_module(library(lists)).
:- use_module(library(random)).


:- consult('src/board').
:- consult('src/database').
:- consult('src/logic').
:- consult('src/utils').
:- consult('src/menu').
:- consult('src/cpu').

game_cycle(GameState):-
    game_over(GameState, Winner), !,
    display_game(GameState),
    congratulate(Winner). 

game_cycle(GameState):-
    display_game(GameState),
    print_player(GameState),
    choose_move(GameState, Move),
    move(GameState, Move, NewGameState),
    game_cycle(NewGameState).

play:-
    show_menu,
    initial_state(Board),
    game_cycle([Board, red]).
