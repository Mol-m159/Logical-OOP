% palind_list(L) — истинно, если список L является палиндромом
palind_list(L) :-
    reverse(L, L).

% Вспомогательный предикат: обращение списка
my_reverse(L, R) :-
    my_reverse_acc(L, [], R).

my_reverse_acc([], Acc, Acc).
my_reverse_acc([H|T], Acc, R) :-
    my_reverse_acc(T, [H|Acc], R).

% Проверка через собственную реализацию reverse
palind_list2(L) :-
    my_reverse(L, L).

% Посимвольное сравнение с концов

palind_list3([]).
palind_list3([_]).
palind_list3([H|T]) :-
    last(T, H),                
    append(Middle, [_], T),    
    palind_list3(Middle).