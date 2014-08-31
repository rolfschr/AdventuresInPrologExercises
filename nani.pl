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
location(envelope, desk).
location(stamp, envelope).
location(key, envelope).

:- dynamic location_s/2.
location_s(object(candle, red, small, 1), kitchen).
location_s(object(apple, red, small, 1), kitchen).
location_s(object(apple, green, small, 1), kitchen).
location_s(object(table, blue, big, 50), kitchen).

:- dynamic door/3.
% door(From, To, IsOpen)
door(office, hall, true).
door(kitchen, office, true).
door(hall, 'dining room', true).
door(kitchen, cellar, false).
door('dining room', kitchen, true).

connect(X, Y, door(X, Y, IsOpen)) :- door(X, Y, IsOpen).
connect(X, Y, door(Y, X, IsOpen)) :- door(Y, X, IsOpen).
connect(X, Y) :- connect(X, Y, _).

%:- dynamic is_open/1.
%is_open(door(office, hall)) :- true.
%is_open(door(kitchen, office)) :- true.
%is_open(door(hall, 'dining room')) :- false.
%is_open(door(kitchen, cellar)) :- false.
%is_open(door('dining room', kitchen)) :- false.
%
%is_open(Here, Next) :- is_open(door(Here, Next)).
%is_open(Here, Next) :- is_open(door(Next, Here)).
%is_closed(Here, Place) :- not(is_open(Here, Place)).

edible(apple).
edible(crackers).

tastes_yucky(broccoli).

:- dynamic turned_on/1.
:- dynamic turned_off/1.
turned_off(flashlight).

:- dynamic here/1.
here(kitchen).

:- dynamic have/1.

%%% DATA END %%%

%%% MOVE BEGIN %%%

goto(Place):-
	can_go(Place),
	move(Place),
	look,
	!.

can_go(Place):-
	here(X),
	connect(X, Place, door(_, _, true)).
can_go(Place):-
	not(room(Place)),
	format('~w is not a room.~n', [Place]),
	!,
	fail.
can_go(Place):-
	here(X),
	not(connect(X, Place, _)),
	format('There is no door to the ~w.~n', [Place]),
	!,
	fail.
can_go(Place):-
	here(X),
	connect(X, Place, door(_, _, false)),
	format('The door to ~w is not open.~n', [Place]),
	!,
	fail.

open_door_to(Place):-
	here(X),
	connect(Place, X, door(_, _, true)),
	true.
open_door_to(Place):-
	here(X),
	connect(Place, X, door(From, To, false)),
	retract(door(From, To, false)),
	asserta(door(From, To, true)).

close_door_to(Place):-
	here(X),
	connect(Place, X, door(_, _, false)).
close_door_to(Place):-
	here(X),
	connect(Place, X, door(_, _, true)),
	retract(door(From, To, true)),
	asserta(door(From, To, false)).

move(Place):-
	retract(here(_)),
	asserta(here(Place)).

%%% MOVE END %%%

%%% OBJECT MANIP BEGIN %%%

take(X):-
	can_take(X),
	take_object(X).

take_s(X):-
	can_take_s(X),
	take_object_s(X).

can_take(Thing) :-
	here(Place),
	is_contained_in(Thing, Place).
can_take(Thing) :-
	format('There is no ~w here.~n', [Thing]),
	fail.

can_take_s(Thing) :-
	here(Room),
	location_s(object(Thing, _, small,_), Room).
can_take_s(Thing) :-
	here(Room),
	location_s(object(Thing, _, big, _), Room),
	format('~w is too big.~n', [Thing]),
	fail.
can_take_s(Thing) :-
	here(Room),
	not(location_s(object(Thing, _, _, _), Room)),
	format('There is no ~w here.~n', [Thing]),
	fail.

take_object(X):-
	retract(location(X,_)),
	asserta(have(X)),
	format('Taken.~n').

take_object_s(X):-
	retract(location_s(object(X, Color, Size, Weight), _)),
	asserta(have(object(X, Color, Size, Weight))),
	format('Taken.~n').

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

inventory :-
	format('You have:~n'),
	have(Thing),
	format('~2|~s~n', [Thing]),
	fail.
inventory.

turn_on(X) :-
	can_turn_on(X),
	asserta(turned_on(X)),
	retract(turned_off(X)).

can_turn_on(X) :-
	have(X),
	turned_off(X).
can_turn_on(X) :-
	format('You cannot turn on ~s.~n', [X]),
	fail.

turn_off(X) :-
	can_turn_off(X),
	asserta(turned_off(X)),
	retract(turned_on(X)).

can_turn_off(X) :-
	not(can_turn_on(X)),
	have(X),
	turned_on(X).
can_turn_off(X) :-
	format('You cannot turn off ~s.~n', [X]),
	fail.

%%% OBJECT MANIP END %%%

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
	format('~2|~w ~n', [X]),
	fail.
list_connections(_).

look :-
	here(Place),
	write('You are in the '), write(Place), nl,
	write('You can see:'), nl,
	list_things(Place),
	write('Neighbouring rooms:'), nl,
	list_connections(Place).

look_in(Place) :-
	list_things(Place).

is_contained_in(T1,T2) :-
	location(T1,T2).
is_contained_in(T1,T2) :-
	location(X,T2),
	is_contained_in(T1,X).



%%% ASK END %%%

%%% TESTS BEGIN %%%

check_all :-
	check_door,
	check_location,
	check_put,
	true.

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

check_put :-
	asserta(here(randomPlace)),
	asserta(have(randomThing)),
	put(randomThing),
	not(have(randomThing)),
	location(randomThing, randomPlace),
	retract(here(randomPlace)),
	retract(location(randomThing, randomPlace)),
	true.

%%% TESTS END %%%
