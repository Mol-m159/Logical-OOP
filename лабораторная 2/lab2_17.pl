% big_sum(A, B, R) - сложение чисел, заданных списками цифр.
% Результат -  список цифр.

big_sum(A, B, R) :-
    reverse(A, RA),
    reverse(B, RB),
    add_digits(RA, RB, 0, RRev),
    reverse(RRev, R).

% add_digits(A, B, Carry, R) - сложение поразрядно справа налево.
add_digits([], [], 0, []) :- !.
add_digits([], [], C, [C]) :- C > 0, !.
add_digits([HA|TA], [], C, R) :-
    S is HA + C,
    D is S mod 10,
    C1 is S // 10,
    add_digits(TA, [], C1, R1),
    R = [D|R1].
add_digits([], [HB|TB], C, R) :-
    S is HB + C,
    D is S mod 10,
    C1 is S // 10,
    add_digits([], TB, C1, R1),
    R = [D|R1].
add_digits([HA|TA], [HB|TB], C, R) :-
    S is HA + HB + C,
    D is S mod 10,
    C1 is S // 10,
    add_digits(TA, TB, C1, R1),
    R = [D|R1].

