:- dynamic bot/2.

choose_difficulty(Bot) :-
    write('----- BOT -----'), nl,
    write('1 - RANDOM'), nl,
    write('2 - GREEDY'), nl,
    read(Option),
    ((Option = 1 ; Option = 2) -> 
        assert(bot(Bot, Option)) ; nl, write('WRONG OPTION, PLEASE ENTER ANOTHER ONE'), nl, fail).