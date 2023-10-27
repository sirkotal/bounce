:- consult('src/board').
:- consult('src/utils').

display_game :- initialize_board(Board), display_board(Board), remove_piece(Board, 2, 3, NewBoard), nl, display_board(NewBoard).

play :- display_game.