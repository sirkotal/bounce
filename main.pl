:- use_module(library(lists)).
:- use_module(library(random)).


:- consult('src/board').
:- consult('src/database').
:- consult('src/logic').
:- consult('src/utils').
:- consult('src/menu').
:- consult('src/database').

test:- 
    initialize_board(Board),
    display_board(Board),
    bot_move(Board, 2, red, NewBoard).

 game_cycle(Board, Player):-
    game_over(Board, Player, Winner), !,
    congratulate(Winner). 

game_cycle(Board, Player):-
    write(Player),nl,
    bot_move(Board, 2, Player, NewBoard),!,
    display_board(NewBoard), !,
    next_player(Player, NextPlayer),  
    game_cycle(NewBoard, NextPlayer).
    /*
    atom_concat('PLAYER TURN: ', Player, Print),
    write(Print), nl,
    choose_move(Board, Player, NextBoard),
    next_player(Player, NextPlayer),
    display_board(NextBoard), !,    
    game_cycle(NextBoard, NextPlayer).*/

play:-
    show_menu,
    initialize_board(Board),
    display_board(Board),
    count_checkers(Board, red, RedCount), write('Number of red checkers: '), write(RedCount), nl,
    game_cycle(Board, red).

//play :- display_game, choose_difficulty(x).
