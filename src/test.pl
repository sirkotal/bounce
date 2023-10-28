print_array([]). % Base case, the list is empty, nothing to print.

print_array([Head | Tail]) :-
    write(Head), % Print the current element
    nl,          % Print a newline character to separate elements
    print_array(Tail). % Recursively print the rest of the list