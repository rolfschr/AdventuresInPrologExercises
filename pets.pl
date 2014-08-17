
pet(dog):- size(medium), noise(woof).
pet(cat):- size(medium), noise(meow).
pet(mouse):- size(small), noise(squeak).

size(X):- ask(size, X).
noise(X):- ask(noise, X).

:- dynamic known/3.
%known(Attr, Val, YesNo).

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
