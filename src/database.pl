:- dynamic bot/2.

choose_difficulty(Bot) :-
    write('----- BOT -----'), nl,
    write(''), nl,
    write('1 - RANDOM'), nl,
    write(''), nl,
    write('2 - GREEDY'), nl,
    write(''), nl,
    repeat,
    write('INSERT AN OPTION'), nl,
    read(Option),
    ((Option = 1 ; Option = 2) -> 
        assert(bot(Bot, Option)) ; nl, write('WRONG OPTION, PLEASE ENTER ANOTHER ONE'), nl, fail).

clear_data :-
    retractall(bot(_,_)).