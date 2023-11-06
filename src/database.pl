:- consult('utils').

/* bot(+Bot, +Difficulty)
   Represents the CPU's configuration */
:- dynamic bot/2.

/* player_name(+Player, +Name)
   Represents the player name */
:- dynamic player_name/2.

/* player_icon(+Player, +Icon)
   Represents the player icon */
:- dynamic player_icon/2.

/* size_board(+Size)
   Represents the board size */
:- dynamic size_board/1.

/* choose_difficulty(+Number, +Bot)
   Configures the CPU's level of difficulty, name and icon */
choose_difficulty(Number, Bot) :-
    (Bot = red -> 
        assert(player_name(Bot, 'Bot 1')), assert(player_icon(Bot, 'X')) ; 
        (player_icon(red, X), X = 'O' -> Icon = 'X'; Icon = 'O'),
        assert(player_name(Bot, 'Bot 2')), assert(player_icon(Bot, Icon))),
    format('----- LEVEL BOT ~d -----', [Number]), nl,
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

/* choose_name(+Number, +Player)
   Configures the Player's name */
choose_name(Number, Player):-
    write(''), nl,
    format('INSERT PLAYER ~d NAME', [Number]), nl,
    write(''), nl,
    repeat,
    read_line(Input),
    atom_codes(String, Input),
    (String = '' -> fail; assert(player_name(Player, String)), !).

/* choose_icon(+Number, +Player)
   Configures the Player's icon */
choose_icon(Number, Player) :-
    write(''), nl,
    format('INSERT PLAYER ~d ICON (ONE CHARACTER ONLY)', [Number]), nl,
    write(''), nl,
    repeat,
    read_line(Input),
    char_codes_to_chars(Input, String),
    length(String, Len),
    [Char|_Rest] = String,
    ((Len > 1 ; player_icon(red, X), X = Char; player_icon(blue, Y), Y = Char) -> nl, write('THAT ICON ISN\'T VALID, PLEASE ENTER ANOTHER ONE'), nl, fail; assert(player_icon(Player, Char)), !).

/* clear_data/0
   Removes the names, icons and bot difficulties from the program */
clear_data :-
    retractall(bot(_,_)),
    retractall(player_name(_,_)),
    retractall(player_icon(_,_)),
    retractall(size_board(_)).