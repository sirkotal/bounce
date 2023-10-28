show_menu :-
    write('----- BOUNCE -----'), nl,
    write(' '), nl,
    write('1 - PLAY'), nl,
    write(' '), nl,
    write('2 - RULES'), nl,
    write(' '), nl,
    write('3 - EXIT'), nl,
    write(' '), nl.

read_menu(X) :- 
    repeat,
    write('INSERT AN OPTION'), nl,
    read(X),
    ((X = 1 ; X = 2 ; X = 3) -> option(X) ; (write('WRONG OPTION, PLEASE ENTER ANOTHER ONE'), nl, fail)).

option(1) :- 
    write('GAME').

option(2) :- 
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
    repeat,
    write(''), nl,
    write('INSERT 1 TO GO BACK TO MENU'), nl,
    read(Y),
    ((Y = 1) -> show_menu, read_menu(_) ; (write('WRONG OPTION, PLEASE ENTER 1 TO GO BACK'), nl, fail)).

option(3) :- halt(0).
