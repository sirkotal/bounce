:- consult('database').

:- use_module(library(random)).

/* show_menu/0
   Displays the game's main menu */
show_menu :-
    write('\33\[2J'),
    write(''), nl,
    write('----- BOUNCE -----'), nl,
    write(''), nl,
    write('1 - PLAY'), nl,
    write(''), nl,
    write('2 - RULES'), nl,
    write(''), nl,
    write('3 - EXIT'), nl,
    write(''), nl,
    read_menu.

/* read_menu/0 
   Receives the user's input in the main menu */
read_menu :- 
    repeat,
    write('INSERT AN OPTION'), nl,
    read(X),
    ((X = 1 ; X = 2 ; X = 3) -> option(X), !; (write('WRONG OPTION, PLEASE ENTER ANOTHER ONE'), nl, fail)).

/* option(+Option)
   Displays the different options based on the user's input */
option(1) :- 
    write('\33\[2J'),
    write(''), nl,
    write('----- MODE -----'), nl,
    write(''), nl,
    write('1 - HUMAN VS HUMAN'), nl,
    write(''), nl,
    write('2 - HUMAN VS BOT'), nl,
    write(''), nl,
    write('3 - BOT VS BOT'), nl,
    write(''), nl,
    read_mode,
    repeat,
    write(''), nl,
    write('ENTER THE SIZE OF THE BOARD (MUST BE EQUAL OR BIGGER THAN 6 AND EVEN):'), nl,
    read(X),
    (X mod 2 =:= 0, X > 5 -> assert(size_board(X)),!; (write('WRONG OPTION, PLEASE ENTER ANOTHER ONE'), nl, fail)).

option(2) :- 
    write('\33\[2J'),
    write(''), nl,
    write('INTRODUCTION: Bounce is a two-player game played on a square board of any even size. The board is initially filled with a checkerboard pattern of red and blue checkers, except the corner squares, which are unoccupied. Mark Steere designed Bounce in August 2023.'), nl,
    write(''), nl,
    write('GROUP: A group here is a monocolored, orthogonally interconnected group of checkers'), nl,
    write(''), nl,
    write('OBJECT: If, at the conclusion of your turn, all of your checkers are in one group, you win.'), nl,
    write(''), nl,
    write('PLAY: Starting with Red, players take turns moving one of their checkers to an unoccupied square (if they have a legal move available. See CHECKER REMOVAL below.)'), nl,
    write(''), nl,
    write('The checker you move must be part of a larger group after your move than it was before your move. '), nl,
    write(''), nl,
    write('CHECKER REMOVAL: If you don\'t have any legal moves availableon your turn, you must instead remove any one of your checkers from the board, concluding your turn'), nl,
    write(''), nl,
    write('INSERT ANYTHING TO GO BACK TO MENU'), nl,
    read(_),
    show_menu.

option(3) :- halt(0).

/* read_mode/0
   Receives the user's regarding the game mode */
read_mode :- 
    repeat,
    write('INSERT AN OPTION'), nl,
    read(X),
    ((X = 1 ; X = 2 ; X = 3) -> version(X), !; (write('WRONG OPTION, PLEASE ENTER ANOTHER ONE'), nl, fail)).

/* version(+Mode)
   Handles the user input by setting the game to the specified mode */
version(1) :- 
    write('\33\[2J'),
    choose_name(1, red),
    choose_icon(1, red),
    choose_name(2, blue),
    choose_icon(2, blue).

version(2) :- 
    write('\33\[2J'),
    write(''), nl,
    choose_name(1, red),
    choose_icon(1, red),
    write('\33\[2J'),
    write(''), nl,
    choose_difficulty(2, blue).

version(3) :-
    write('\33\[2J'),
    write(''), nl,
    choose_difficulty(1, red),
    write('\33\[2J'),
    write(''), nl,
    choose_difficulty(2, blue).

/* starting_player(-Player)
   Selects the first player to play */
starting_player(Player) :-
    write('\33\[2J'),
    write(''), nl,
    write('Who plays first?'), nl,
    write(''), nl,
    write('1 - Player 1'), nl,
    write(''), nl,
    write('2 - Player 2'), nl,
    write(''), nl,
    write('3 - Random'), nl,
    write(''), nl,
    read_player(Option),
    starting(Option, Player).

/* read_player(-Option)
   Receives the user's regarding the starting player */
read_player(X) :- 
    repeat,
    write('INSERT AN OPTION'), nl,
    read(X),
    ((X = 1 ; X = 2 ; X = 3) -> !; (write('WRONG OPTION, PLEASE ENTER ANOTHER ONE'), nl, fail)).

/* starting(+Option, -Player)
   Handles the user input by setting the first player to play */
starting(1, red).
starting(2, blue).
starting(3, Player):-
    random(1, 3, Index),
    (Index = 1 -> Player = red; Player = blue).


    