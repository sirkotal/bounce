:- use_module(library(lists)).

:- consult('src/board').
:- consult('src/utils').

display_game :- initialize_board(Board), display_board(Board), remove_checker(Board, 2, 3, NewBoard), nl, display_board(NewBoard),
                place_checker(NewBoard, 2, 2, red, NewNewBoard), nl, display_board(NewNewBoard).

play :- display_game.