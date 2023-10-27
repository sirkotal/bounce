:- use_module(library(lists)).

:- consult('src/board').
:- consult('src/utils').

display_game :- initialize_board(Board), display_board(Board), remove_checker(Board, 2, 3, NewBoard), nl, display_board(NewBoard),
                checker_move(NewBoard, 2, 4, 2, 2, red, UpdateBoard), nl, display_board(UpdateBoard).

play :- display_game.