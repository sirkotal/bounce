# Bounce

## PFL Practical Work - Prolog Board Game

### Developed by:

- João Pedro Rodrigues Coutinho (up202108787)
- Miguel Jorge Medeiros Garrido (up202108889)

## Instalation and Execution

To play the game, in addition to the game's source code, you must have [SICStus Prolog 4.8](https://sicstus.sics.se/download4.html) currently installed on your computer. 

On the SICStus interpreter, consult the *main.pl* file, located in the game's folder:

```?- consult('main.pl').```

***Note:*** *If you're on Windows, you can also do this by selecting the `File` → `Consult...` options on the SICStus terminal and selecting **main.pl**.*
    
To start the game and enter the main menu, run the `play/0` predicate:

```?- play.```

## Game Description

Bounce is a two-player game created by Mark Steere in August 2023. It is played on a square board of any even size (the default being 8x8), filled with a checkerboard pattern of both red and blue checkers, with the exception of the corner squares which are unoccupied.

![initial-board](images/figure_1.png)

Bounce is a relatively simple game to play: starting with Red, players take turns moving one of their checkers to an unoccupied square (if they have a legal move available). 
A move is "legal" when the checker you move is part of a larger group than it was before your move.

![valid-move](images/figure_2.png)

However, if you don't have any legal moves available on your turn, you must instead remove any one of your checkers from the board concluding your turn.

To win a game, all you need to do is to have all of your checkers in one group at the end of your turn.

![win-board](images/figure_3.png)

***Source:*** <https://www.marksteeregames.com/Bounce_rules.pdf>

## Bibliography

- <https://www.marksteeregames.com/Bounce_rules.pdf>
- <https://www.swi-prolog.org/>
- <https://stackoverflow.com/>
- <https://eclipseclp.org/doc/bips/index.html>