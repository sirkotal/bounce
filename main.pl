:- use_module(library(lists)).

:- consult('src/board').
:- consult('src/utils').
:- consult('src/logic').
:- consult('src/database').

display_game :- initialize_board(Board), display_board(Board), nl,
                valid_move(Board, 3, 4, 2, 9, blue, UpdateBoard), nl, display_board(UpdateBoard).

play :- display_game, choose_difficulty(x).