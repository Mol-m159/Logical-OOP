:- object(tests).

    :- public(run/0).
    :- private(check/2).
    :- meta_predicate(check(*, 0)).

    run :-
        format('tests: basic check~n', []),

	%Проверки на упражнение 1
	%Существование факта "butsy — кошка"
        check('ex1: cat(butsy)',       first::cat(butsy)),
	%Существование факта "flash — собака"
        check('ex1: dog(flash)',       first::dog(flash)),
	%butsy не собака
        check('ex1: \\+ dog(butsy)',   \+ first::dog(butsy)),
	%flash не кот
        check('ex1: \\+ cat(flash)',   \+ first::cat(flash)),
	%Кот один и это butsy
        check('ex1: cat/1 == [butsy]', (findall(X1, first::cat(X1), L1), L1 == [butsy])),
	%Собака одна и это flash
        check('ex1: dog/1 == [flash]', (findall(X2, first::dog(X2), L2), L2 == [flash])),

	%Проверки на упражнение 2

 	%butsy — животное (кошка)
        check('ex2: animal(butsy)', second::animal(butsy)),
        %flash — животное (собака)
        check('ex2: animal(flash)', second::animal(flash)),
        %Множество животных ровно {butsy, flash}
        check('ex2: animal/1 == [butsy, flash]',
              (findall(X3, second::animal(X3), L3), msort(L3, S3), S3 == [butsy, flash])),
        %cat/1 и dog/1 доступны через second
        check('ex2: inherited cat(butsy)',  second::cat(butsy)),
        check('ex2: inherited dog(flash)',  second::dog(flash)),

	%Проверки на упражнение 3

        %Снаружи защищённые методы недоступны: вызов должен бросить ошибку доступа
        check('ex3: \\+ catch(third::cat(butsy), _, fail)',
              \+ catch(third::cat(butsy), _, fail)),
        check('ex3: \\+ catch(third::dog(flash), _, fail)',
              \+ catch(third::dog(flash), _, fail)),

	%Проверки на упражнение 4

        %Изнутри fourth ::dog/::cat доступны (protected виден наследникам)
        check('ex4: animal(flash) via ::dog', fourth::animal(flash)),
        check('ex4: animal(butsy) via ::cat', fourth::animal(butsy)),
        %Множество животных ровно {butsy, flash}
        check('ex4: animal/1 == [butsy, flash]',
              (findall(X4, fourth::animal(X4), L4), msort(L4, S4), S4 == [butsy, flash])),
        %Снаружи dog/1 и cat/1 недоступны даже для fourth
        check('ex4: \\+ catch(fourth::dog(flash), _, fail)',
              \+ catch(fourth::dog(flash), _, fail)),
        check('ex4: \\+ catch(fourth::cat(butsy), _, fail)',
              \+ catch(fourth::cat(butsy), _, fail)),

 	%Проверки на упражнение 5

        check('ex5: pet/1 is public',
              object_property(fifth, declares(pet/1, _))),
        %horse/1 защищён: снаружи недоступен
        check('ex5: \\+ catch(fifth::horse(star), _, fail)',
              \+ catch(fifth::horse(star), _, fail)),
        check('ex5: \\+ catch(fifth::horse(iron), _, fail)',
              \+ catch(fifth::horse(iron), _, fail)),
        %animal/1 включает лошадей
        check('ex5: animal(star)', fifth::animal(star)),
        check('ex5: animal(iron)', fifth::animal(iron)),
        %Множество животных ровно {butsy, flash, star, iron}
        check('ex5: animal/1 == [butsy, flash, iron, star]',
              (findall(X5, fifth::animal(X5), L5), msort(L5, S5),
               S5 == [butsy, flash, iron, star])),
        check('ex5: pet/1 == [butsy, flash]',
              (findall(X6, fifth::pet(X6), L6), msort(L6, S6),
               S6 == [butsy, flash])),

	%Проверки на упражнение 6

        %Kate владеет кошкой butsy и собакой flash
        check('ex6: owner(kate, butsy)', sixth::owner(kate, butsy)),
        check('ex6: owner(kate, flash)', sixth::owner(kate, flash)),
        %Kate НЕ владеет лошадьми
        check('ex6: \\+ owner(kate, star)', \+ sixth::owner(kate, star)),
        check('ex6: \\+ owner(kate, iron)', \+ sixth::owner(kate, iron)),
        %Множество питомцев Kate ровно {butsy, flash}
        check('ex6: owner(kate, _) == [butsy, flash]',
              (findall(X7, sixth::owner(kate, X7), L7), msort(L7, S7),
               S7 == [butsy, flash])),
        %Bob владеет только star
        check('ex6: owner(bob, star)', sixth::owner(bob, star)),
        check('ex6: \\+ owner(bob, iron)', \+ sixth::owner(bob, iron)),
        check('ex6: \\+ owner(bob, butsy)', \+ sixth::owner(bob, butsy)),
        check('ex6: \\+ owner(bob, flash)', \+ sixth::owner(bob, flash)),
        %Множество владений Bob ровно {star}
        check('ex6: owner(bob, _) == [star]',
              (findall(X8, sixth::owner(bob, X8), L8), L8 == [star])),


	%Проверки на упражнение 7
        % Запуск swilgt -l Set1TestsLoader.lgt
        % ?- table_animal_printer::print(sixth).

	%Проверки на упражнение 8

        %Объекты существуют, протокол реализован
        check('ex8: dog_object is object', current_object(dog_object)),
        check('ex8: cat_object is object', current_object(cat_object)),
        %say/1 защищён: снаружи недоступен
        check('ex8: \\+ catch(dog_object::say(_), _, fail)',
              \+ catch(dog_object::say(_), _, fail)),
        check('ex8: \\+ catch(cat_object::say(_), _, fail)',
              \+ catch(cat_object::say(_), _, fail)),
        %say_something/0 печатает "wow!!!" для собаки
        check('ex8: dog says wow!!!',
              (with_output_to(string(S1),
                              dog_object::say_something),
               S1 == "wow!!!\n")),
        %say_something/0 печатает "meow!!!" для кошки
        check('ex8: cat says meow!!!',
              (with_output_to(string(S2),
                              cat_object::say_something),
               S2 == "meow!!!\n")),


	%Проверки на упражнение 9

        %Объект существует, exp/3 публичен, fact/2 и sqr/2 приватны
        check('ex9: taylor is object', current_object(taylor)),
        check('ex9: exp/3 is public',
      		(object_property(taylor, declares(exp/3, Ps1)), memberchk(public, Ps1))),
	check('ex9: fact/2 is private',
        	(object_property(taylor, declares(fact/2, Ps2)), memberchk(private, Ps2))),
	check('ex9: sqr/2 is private',
        	(object_property(taylor, declares(sqr/2, Ps3)), memberchk(private, Ps3))),
        %fact/2 через контекст <</2
        check('ex9: fact(0) == 1',  (taylor<<fact(0, F0), F0 == 1)),
        check('ex9: fact(1) == 1',  (taylor<<fact(1, F1), F1 == 1)),
        check('ex9: fact(5) == 120', (taylor<<fact(5, F5), F5 == 120)),
        check('ex9: fact(10) == 3628800',
              (taylor<<fact(10, F10), F10 == 3628800)),

        %sqr можно проверить ?- taylor<<sqr(3, S).

        %exp/3: базовый случай
        check('ex9: exp(_, 0) == 1.0',
              (taylor::exp(5, 0, R0), R0 == 1.0)),
        %exp/3: 1 член → 1 + X
        check('ex9: exp(1, 1) == 2.0',
              (taylor::exp(1, 1, R1), abs(R1 - 2.0) < 1.0e-9)),
        %exp/3: 2 члена → 1 + X + X^2/2
        check('ex9: exp(1, 2) == 2.5',
              (taylor::exp(1, 2, R2), abs(R2 - 2.5) < 1.0e-9)),
        %exp/3: 3 члена → 1 + X + X^2/2 + X^3/6
        check('ex9: exp(1, 3) ~ 2.6667',
              (taylor::exp(1, 3, R3), abs(R3 - 8.0/3.0) < 1.0e-9)),
        %exp/3: приближение e^1 при большом N
        check('ex9: exp(1, 10) ~ e',
              (taylor::exp(1, 10, R10), abs(R10 - 2.718281828459045) < 1.0e-6)),
        %exp/3: X = 0 → всегда 1.0
        check('ex9: exp(0, 5) == 1.0',
              (taylor::exp(0, 5, Rz), abs(Rz - 1.0) < 1.0e-9)),

	%Проверки на упражнение 10

        check('ex10: eval(t) == t', evaluator::eval(t, t)),
        check('ex10: eval(f) == f', evaluator::eval(f, f)),
        %Отрицание
        check('ex10: eval(not(t)) == f', evaluator::eval(not(t), f)),
        check('ex10: eval(not(f)) == t', evaluator::eval(not(f), t)),
        check('ex10: eval(not(not(t))) == t',
              evaluator::eval(not(not(t)), t)),
        
        check('ex10: eval(and(t,t)) == t', evaluator::eval(and(t, t), t)),
        check('ex10: eval(and(t,f)) == f', evaluator::eval(and(t, f), f)),
        check('ex10: eval(and(f,t)) == f', evaluator::eval(and(f, t), f)),
        check('ex10: eval(and(f,f)) == f', evaluator::eval(and(f, f), f)),
        
        check('ex10: eval(or(t,t)) == t', evaluator::eval(or(t, t), t)),
        check('ex10: eval(or(t,f)) == t', evaluator::eval(or(t, f), t)),
        check('ex10: eval(or(f,t)) == t', evaluator::eval(or(f, t), t)),
        check('ex10: eval(or(f,f)) == f', evaluator::eval(or(f, f), f)),
        
        check('ex10: eval(and(or(t,f), not(and(t,t)))) == f',
              evaluator::eval(and(or(t, f), not(and(t, t))), f)),
       
        check('ex10: eval(or(and(t,f), not(f))) == t',
              evaluator::eval(or(and(t, f), not(f)), t)),
        
        check('ex10: eval(and(t,t), V) has unique solution',
              (findall(V, evaluator::eval(and(t, t), V), Vs),
               Vs == [t])),
        check('ex10: eval(and(or(t,f), not(and(t,t))), V) unique',
              (findall(V, evaluator::eval(and(or(t,f), not(and(t,t))), V), Vs2),
               Vs2 == [f])),

	%Проверки на упражнение 11

        %Объекты существуют
        check('ex11: door_lock is object', current_object(door_lock)),
        check('ex11: my_door_lock is object', current_object(my_door_lock)),
        %check/1 публичен, password/1 защищён
        check('ex11: check/1 is public',
              (object_property(door_lock, declares(check/1, P11a)),
               memberchk(public, P11a))),
        check('ex11: password/1 is protected',
              (object_property(door_lock, declares(password/1, P11b)),
               memberchk(protected, P11b))),
        %Снаружи password/1 недоступен
        check('ex11: \\+ catch(door_lock::password(_), _, fail)',
              \+ catch(door_lock::password(_), _, fail)),
        check('ex11: \\+ catch(my_door_lock::password(_), _, fail)',
              \+ catch(my_door_lock::password(_), _, fail)),
        %door_lock: базовые пароли проходят check/1
        check('ex11: door_lock check(password)',
              door_lock::check('password')),
        check('ex11: door_lock check(award_ed)',
              door_lock::check('award_ed')),
        check('ex11: door_lock check(42)',
              door_lock::check('42')),
        %door_lock: посторонний пароль не проходит
        check('ex11: \\+ door_lock check(new_pass)',
              \+ door_lock::check('new_pass')),
        check('ex11: \\+ door_lock check(secret)',
              \+ door_lock::check('secret')),
        check('ex11: \\+ door_lock check(wrong)',
              \+ door_lock::check('wrong')),
        %my_door_lock: унаследованные пароли 
        check('ex11: my_door_lock check(password)',
              my_door_lock::check('password')),
        check('ex11: my_door_lock check(award_ed)',
              my_door_lock::check('award_ed')),
        check('ex11: my_door_lock check(42)',
              my_door_lock::check('42')),
        %my_door_lock: новые пароли 
        check('ex11: my_door_lock check(new_pass)',
              my_door_lock::check('new_pass')),
        check('ex11: my_door_lock check(secret)',
              my_door_lock::check('secret')),
        %my_door_lock: посторонний пароль не проходит
        check('ex11: \\+ my_door_lock check(wrong)',
              \+ my_door_lock::check('wrong')),
        %Множество паролей my_door_lock = 5 (3 базовых + 2 новых)
        check('ex11: my_door_lock has 5 passwords',
              (findall(P11c, my_door_lock::check(P11c), L11),
               msort(L11, S11),
               S11 == ['42', 'award_ed', 'new_pass', 'password', 'secret'])),
        %Множество паролей door_lock = 3
        check('ex11: door_lock has 3 passwords',
              (findall(P11d, door_lock::check(P11d), L11d),
               msort(L11d, S11d),
               S11d == ['42', 'award_ed', 'password'])),

	%Проверки на упражнение 12


        %Объект существует, методы публичны
        check('ex12: animal_factory is object',
              current_object(animal_factory)),
        check('ex12: create_cat/1 is public',
              (object_property(animal_factory, declares(create_cat/1, P12a)),
               memberchk(public, P12a))),
        check('ex12: create_dog/1 is public',
              (object_property(animal_factory, declares(create_dog/1, P12b)),
               memberchk(public, P12b))),
        check('ex12: list_animals/0 is public',
              (object_property(animal_factory, declares(list_animals/0, P12c)),
               memberchk(public, P12c))),
        %Очистка перед тестами (изоляция от предыдущих прогонов)
        check('ex12: cleanup',
              (animal_factory << retractall(animal_(_, _)))),
        %Изначально список пуст
        check('ex12: initially empty',
              (findall(T12a-N12a, animal_factory<<animal_(T12a, N12a), L12a),
               L12a == [])),
        %Создаём кошку
        check('ex12: create_cat(butsy)',
              animal_factory::create_cat(butsy)),
        %Создаём собаку
        check('ex12: create_dog(flash)',
              animal_factory::create_dog(flash)),
        %Проверяем, что факты добавлены (через <</2, т.к. animal_/2 приватный)
        check('ex12: cat butsy stored',
              (animal_factory << animal_(cat, butsy))),
        check('ex12: dog flash stored',
              (animal_factory << animal_(dog, flash))),
        %Идемпотентность: повторное создание не дублирует
        check('ex12: create_cat(butsy) idempotent',
              animal_factory::create_cat(butsy)),
        %list_animals/0 печатает всех животных
       check('ex12: list_animals would print 2 animals',
              (findall(T12d-N12d, animal_factory<<animal_(T12d, N12d), L12d),
               msort(L12d, S12d),
               S12d == [cat-butsy, dog-flash])),
        %Создаём ещё одно животное
        check('ex12: create_cat(murka)',
              animal_factory::create_cat(murka)),
	 check('ex12: list_animals would print 3 animals',
              (findall(T12e-N12e, animal_factory<<animal_(T12e, N12e), L12e),
               msort(L12e, S12e),
               S12e == [cat-butsy, cat-murka, dog-flash])),

        %animal_/2 и add_animal/2 приватны (снаружи недоступны)
        check('ex12: \\+ catch(animal_factory::animal_(_, _), _, fail)',
              \+ catch(animal_factory::animal_(_, _), _, fail)),
        check('ex12: \\+ catch(animal_factory::add_animal(_, _), _, fail)',
              \+ catch(animal_factory::add_animal(_, _), _, fail)).


    check(Label, Goal) :-
        (   catch(Goal, Error, (format('    ERROR ~w: ~w~n', [Label, Error]), fail)) ->
            format('    ok:   ~w~n', [Label])
        ;   format('    FAIL: ~w~n', [Label])
        ).

:- end_object.