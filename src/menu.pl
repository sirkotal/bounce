show_menu :-write('----- BOUNCE -----'), nl,
            write(' '), nl,
            write('1 - PLAY'), nl,
            write(' '), nl,
            write('2 - RULES'), nl,
            write(' '), nl,
            write('3 - EXIT'), nl,
            write(' '), nl.



read_menu(X) :- repeat,
                write('INSERT AN OPTION'), nl,
                read(X),
                ((X = 1 ; X = 2 ; X = 3) -> option(X) ; (write('WRONG OPTION, PLEASE ENTER ANOTHER ONE'), nl, fail)).

option(1) :- write('GAME').

option(2) :- write('RULES').

option(3) :- write('LEFT').



              