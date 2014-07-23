%%% DATA BEGIN %%%

room(kitchen).
room(office).
room(hall).
room('dining room').
room(cellar).

:- dynamic location/2.
location(desk, office).
location(apple, kitchen).
location(flashlight, desk).
location('washing machine', cellar).
location(nani, 'washing machine').
location(broccoli, kitchen).
location(crackers, kitchen).
location(computer, office).

door(office, hall).
door(kitchen, office).
door(hall, 'dining room').
door(kitchen, cellar).
door('dining room', kitchen).

connect(X,Y) :- door(X,Y).
connect(X,Y) :- door(Y,X).

edible(apple).
edible(crackers).

tastes_yucky(broccoli).

turned_off(flashlight).

:- dynamic here/1.
here(kitchen).

%%% DATA END %%%

%%% MOVE BEGIN %%%

goto(Place):-
	can_go(Place),
	move(Place),
	look,
	true.
	%!.

can_go(Place):-
	here(X),
	connect(X, Place).
can_go(_):-
	format('You can''t get there from here.'), nl,
	fail.

move(Place):-
	retract(here(_)),
	asserta(here(Place)).

%%% MOVE END %%%

%%% TAKE/PUT BEGIN %%%

take(X):-
	can_take(X),
	take_object(X).

can_take(Thing) :-
	here(Place),
	location(Thing, Place).
can_take(Thing) :-
	format('There is no ~w here.', [Thing]),
	nl, fail.

take_object(X):-
	retract(location(X,_)),
	asserta(have(X)),
	format('taken'), nl.

put(X) :-
	can_put(X),
	put_object(X).

can_put(Thing) :-
	have(Thing).
can_put(Thing) :-
	format('You do not have ~w!', [Thing]),
	nl, fail.

put_object(X) :-
	here(Place),
	asserta(location(X,Place)),
	retract(have(X)),
	format('Put.'), nl.


%%% TAKE/PUT END %%%

%%% ASK BEGIN %%%

where_food(X,Y) :-  location(X,Y), edible(X).
where_food(X,Y) :-  location(X,Y), tastes_yucky(X).


list_things(Place) :-
	location(X, Place),
	tab(2),
	format('~w', [X]),
	nl,
	fail.
list_things(_).

list_connections(Place) :-
	connect(Place, X),
	tab(2),
	write(X),
	nl,
	fail.
list_connections(_).

look :-
	here(Place),
	write('You are in the '), write(Place), nl,
	write('You can see:'), nl,
	list_things(Place),
	write('You can go to:'), nl,
	list_connections(Place).

look_in(Place) :-
	list_things(Place).

%%% ASK END %%%

%%% TESTS BEGIN %%%

is_room(MaybeRoom) :-
	room(MaybeRoom).
is_room(MaybeRoom) :-
	not(room(MaybeRoom)),
	format('Error: ~w is not a room!~n', [MaybeRoom]).

check_location :-
	location(_, MaybeRoom),
	is_room(MaybeRoom),
	fail.
check_location.

check_door :-
	door(MaybeRoom1, MaybeRoom2),
	is_room(MaybeRoom1),
	is_room(MaybeRoom2),
	fail.
check_door.

%%% TESTS END %%%
