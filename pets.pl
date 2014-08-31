
pet(dog):- size(medium), noise(woof).
pet(cat):- size(medium), noise(meow).
pet(mouse):- size(small), noise(squeak).

size(X):- menuask(size, X, [large, medium, small]).
noise(X):- ask(noise, X).

:- dynamic known/3.
%known(Attr, Val, YesNo).
:- dynamic known/2.
%known(Attr, Val).

ask(Attr, Val):-
	not(known(Attr, Val, _)),
	format('~w:~w (yes/no) ? ', [Attr, Val]),
	read(YesNo),
	assertz(known(Attr, Val, YesNo)),
	ask(Attr, Val),
	!.
ask(Attr, Val):-
	known(Attr, Val, yes),
	!.
ask(Attr, Val):-
	known(Attr, Val, _),
	fail,
	!.

menuask(Attr, Val, LVals) :-
	not(known(Attr, Val, _)),
	menu_display(Attr, LVals),
	menu_select(LVals, Val),
	assertz(known(Attr, Val, yes)).
menuask(Attr, Val, _) :-
	ask(Attr, Val).

menu_display(Attr, X) :-
	format('~w:~n', [Attr]),
	menu_display(Attr, X, 1).
menu_display(_, [], _).
menu_display(Attr, [H|T], N) :-
	format('~w) ~w~n', [N, H]),
	Ninc is N + 1,
	menu_display(Attr, T, Ninc).

menu_select(LVals, Val) :-
	format('Number? '),
	read(N),
	menu_select(N, LVals, Val).
menu_select(1, [H|_], H).
menu_select(N, [_|T], Select) :-
	Ndec is N - 1,
	menu_select(Ndec, T, Select).
