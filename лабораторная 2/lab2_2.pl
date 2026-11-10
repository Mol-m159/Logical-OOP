% sum_to(N, S) - S = 1 + 2 + ... + N
sum_to(0, 0) :- !.
sum_to(N, S) :-
    N > 0,
    N1 is N - 1,
    sum_to(N1, S1),
    S is S1 + N.

% read_natural(-N) - читает натуральное число с консоли
read_natural(N) :-
    write('Enter N (natural number >= 0): '),
    flush_output,
    catch(read(Num), _, fail),
    (   integer(Num), Num >= 0
    ->  N = Num
    ;   writeln('Error: please enter a non-negative integer.'),
        read_natural(N)
    ).

main :-
    writeln('=== Sum of numbers from 1 to N ==='),
    read_natural(N),
    sum_to(N, S),
    format('sum_to(~w) = ~w~n', [N, S]).