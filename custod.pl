%%% CUSTOMER BEGIN %%%

% customer(name,city,credit-rating)
customer(tom,toronto,aaa).
customer(nancy,newcastle,bbb).
customer(bernd,berlin,aaa).
customer(pierre,paris,ccc).
customer(mishka,moscow,bbb).
customer(sven,stockholm,aaa).

good_customer(X) :- customer(X,_,Rating), good_rating(Rating).

good_rating(Rating) :- atom_chars(Rating, [H|_]), H = a.
good_rating(Rating) :- atom_chars(Rating, [H|_]), H = b.

%%% CUSTOMER END %%%

% item(id,name,when-to-rebuy)
item(p1,lotr,10).
item(p2,lotf,10).
item(p3,ulyssis,0).
item(p4,great_expecations,10).
item(p5,lionking,5).

%%% INVENTORY BEGIN %%%

% inventory(id,quantity)
:- dynamic inventory/2.
inventory(p1,5).
inventory(p2,24).
inventory(p3,3).
inventory(p4,2).
inventory(p5,23).

% update_inventory(id,delta)
update_inventory(Id, Delta) :-
	inventory(Id, CurrentQuantity),
	NewQuantity is CurrentQuantity + Delta,
	NewQuantity >= 0,
	retract(inventory(Id, CurrentQuantity)),
	asserta(inventory(Id, NewQuantity)),
	!.
update_inventory(Id, Delta) :-
	item(Id, Name, _),
	inventory(Id, CurrentQuantity),
	CurrentQuantity + Delta < 0,
	format('Not enough ~w (~w) in stock.~n', [Name, Id]),
	!,
	fail.
update_inventory(Name, Delta) :-
	item(Id, Name, _),
	update_inventory(Id, Delta).

get_inventory(Name) :- item(Id,Name,_),inventory(Id, Amount), write(Amount).

item_quantity(Name, Quantity) :- item(Id,Name,_), inventory(Id, Quantity).

list_inventory :-
	format('Inventory:'),
	nl,
	item_quantity(Item, Quantity),
	tab(2),
	format('~w: ~w', [Item, Quantity]),
	nl,
	fail.
list_inventory.

%%% INVENTORY END %%%


%%% ORDERS BEGIN %%%

valid_order(Customer, ItemName, Quantity) :-
	item(ItemId, ItemName, _),
	!, % why here?
	valid_order(Customer, ItemId, Quantity).

valid_order(Customer, ItemId, QuantityWanted) :-
	customer(Customer, _, _),
	good_customer(Customer),
	inventory(ItemId, QuantityInStock),
	QuantityInStock >= QuantityWanted,
	!.

reorder(ItemId) :-
	item(ItemId, Name, ReorderQuantity),
	inventory(ItemId, QuantityInStock),
	QuantityInStock < ReorderQuantity,
	format('Need to reorder ~w(~w).~n', [Name, ItemId]),
	!.
reorder(ItemId) :-
	item(ItemId, Name, _),
	format('There is enough of ~w(~w) in stock.~n', [Name, ItemId]),
	!.
reorder(Name) :-
	item(ItemId, Name, _),
	reorder(ItemId).

%%% ORDERS END %%%
