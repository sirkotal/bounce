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

<p align="center">
  <img src="images/figure_1.png" alt="initial-board">
</p>

Bounce is a relatively simple game to play: starting with Red, players take turns moving one of their checkers to an unoccupied square (if they have a legal move available). 
A move is "legal" when the checker you move is part of a larger group than it was before your move.

<p align="center">
  <img src="images/figure_2.png" alt="valid-move">
</p>

However, if you don't have any legal moves available on your turn, you must instead remove any one of your checkers from the board, concluding your turn.

To win a game, all you need to do is to have all of your checkers in one group at the end of your turn.

<p align="center">
  <img src="images/figure_3.png" alt="win-board">
</p>


***Source:*** <https://www.marksteeregames.com/Bounce_rules.pdf>

## Game Logic

### Internal Game State Representation

The internal representation of the game's state is a structure composed of:

- ***Board*** → a NxN matrix, where N is an even integer; each cell of the matrix can be either `O` (red), `X` (blue) or `-` (empty)
- ***Player*** → represents the current player, which is either `red` or `blue`

**Initial State**:

```prolog
(
    [
        [empty, blue, red, blue, red, blue, red, empty],
        [blue, red, blue, red, blue, red, blue, red],
        [red, blue, red, blue, red, blue, red, blue],
        [blue, red, blue, red, blue, red, blue, red],
        [red, blue, red, blue, red, blue, red, blue],
        [blue, red, blue, red, blue, red, blue, red],
        [red, blue, red, blue, red, blue, red, blue],
        [empty, red, blue, red, blue, red, blue, empty]
    ],
    red)
```

> The initial state of the board is always the same (for boards of the same size) - filled with a checkerboard pattern of both red and blue checkers, with the exception of the corner squares which are unoccupied, and with Red making the first move.

**Intermediate State**:

```prolog
(
    [
        [empty, blue, empty, blue, red, blue, red, red],
        [blue, red, blue, red, blue, red, blue, red],
        [red, blue, red, blue, red, blue, red, blue],
        [blue, red, empty, red, blue, red, blue, red],
        [red, blue, red, blue, red, blue, red, blue],
        [blue, red, blue, red, blue, red, blue, red],
        [red, blue, red, blue, red, blue, red, blue],
        [empty, red, blue, red, blue, red, blue, blue]
    ],
    blue)
```

> This is an example of how the board could look in an intermediate state, where both Red and Blue have moved checkers but no pieces have been removed from the board yet.

**Final State**:

```prolog
(
    [
        [red, red, red, red, red, red, red, blue],
        [empty, blue, blue, red, blue, blue, blue, blue],
        [blue, blue, blue, blue, blue, blue, blue, blue],
        [blue, blue, blue, blue, blue, red, blue, red],
        [blue, blue, red, blue, red, red, red, red],
        [blue, red, red, red, red, red, red, red],
        [blue, blue, red, red, red, red, red, red],
        [blue, blue, blue, red, red, empty, empty, empty]
    ],
    red)
```

> This represents a possible state of the game in its final phase, where Blue has won the game by putting all of his checkers in one group.

### Game State Visualization

### Move Validation and Execution

### List of Valid Moves

### End of Game

### Game State Evaluation

### Computer Plays

## Bibliography

- <https://www.marksteeregames.com/Bounce_rules.pdf>
- <https://www.swi-prolog.org/>
- <https://stackoverflow.com/>
- <https://eclipseclp.org/doc/bips/index.html>