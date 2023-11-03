/* difficulty(+Bot,+Difficulty) */
/* Represents the CPU's difficulty level */
:- dynamic difficulty/2.

/* difficulty_level(+Level) */
/* Stores the CPU's difficulty level in the dynamic database */
difficulty_level(1) :- write('Prepare to Win!'), nl, asserta(difficulty(Bot, 1)).
difficulty_level(2) :- write('Prepare to Lose!'), nl, asserta(difficulty(Bot, 2)).

/* choose_difficulty(+Bot) */
/* Choose the CPU's level of difficulty */
choose_difficulty(Bot) :-
    write('Difficulty:'), nl,
    write('1 - Can I Play, Daddy?'), nl,
    write('2 - I Am Death Incarnate!'), nl,
    write('> '),
    read(Option),
    ((Option = 1 ; Option = 2) -> 
        difficulty_level(Option) ; nl, write('PLEASE SELECT AN ACTUAL DIFFICULTY LEVEL.'), nl, fail).