:- consult('src/board').
:- consult('src/logic').
:- consult('src/menu').

/* game_cycle(+GameState)
   Keeps the game (loop) running */
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

/* play/0 
   Starts the game and clears its data when it ends */
play:-
    show_menu,
    size_board(Size),
    initial_state(Size,GameState),
    game_cycle(GameState),
    clear_data.
