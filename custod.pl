%%% CUSTOMER BEGIN %%%

% customer(CustomerName,City,Rating)
customer(tom,toronto,aaa).
customer(nancy,newcastle,bbb).
customer(bernd,berlin,aaa).
customer(pierre,paris,ccc).
customer(mishka,moscow,bbb).
customer(sven,stockholm,aaa).

good_customer(X):- customer(X,_,Rating), good_rating(Rating).

good_rating(Rating):- atom_chars(Rating, [H|_]), H = a.
good_rating(Rating):- atom_chars(Rating, [H|_]), H = b.

%%% CUSTOMER END %%%


%%% INVENTORY BEGIN %%%

% item(ItemId, ItemName, WhenToReorder)
item(p1, lotr, 10).
item(p2, lotf, 10).
item(p3, ulyssis, 0).
item(p4, great_expecations, 10).
item(p5, lionking, 5).

% inventory(ItemId, CurrentAmount)
:- dynamic inventory/2.
inventory(p1, 5).
inventory(p2, 24).
inventory(p3, 3).
inventory(p4, 2).
inventory(p5, 23).


% update_inventory(ItemId, Delta))
update_inventory(ItemId, Delta):-
	inventory(ItemId, CurrentAmount),
	NewAmount is CurrentAmount + Delta,
	NewAmount >= 0,
	retract(inventory(ItemId, CurrentAmount)),
	asserta(inventory(ItemId, NewAmount)),
	!.
update_inventory(ItemId, Delta):-
	item(ItemId, ItemName, _),
	inventory(ItemId, CurrentAmount),
	CurrentAmount + Delta < 0,
	format('Not enough ~w (~w) in stock.~n', [ItemName, ItemId]),
	!,
	fail.
update_inventory(ItemName, Delta):-
	item(ItemId, ItemName, _),
	update_inventory(ItemId, Delta).

item_quantity(ItemName, Amount):- item(ItemId, ItemName, _), inventory(ItemId, Amount).

list_inventory:-
	format('Inventory:'),
	nl,
	item_quantity(ItemName, Amount),
	tab(2),
	format('~w: ~w', [ItemName, Amount]),
	nl,
	fail.
list_inventory.

%%% INVENTORY END %%%


%%% ORDERS BEGIN %%%

% order(CustomerName, ItemId, QuantityWanted)
:- dynamic order/3.

order:-
	format('Customer name: '), read(CustomerName),
	(customer(CustomerName, _, _) -> true; format('Customer doesn\'t exist!~n'), false),
	(good_customer(CustomerName) -> true; format('Customer is not a good customer!~n'), false),
	format('Item name: '), read(ItemName),
	(item(ItemId, ItemName, _) -> true; format('This item doesn\t exist!~n'), false),
	format('How much? '), read(QuantityWanted),
	update_inventory(ItemId, -QuantityWanted),
	assertz(order(CustomerName, ItemId, QuantityWanted)),
	reorder(ItemId).

valid_order(Customer, ItemName, Amount):-
	item(ItemId, ItemName, _),
	!, % why here?
	valid_order(Customer, ItemId, Amount).

valid_order(Customer, ItemId, QuantityWanted):-
	customer(Customer, _, _),
	good_customer(Customer),
	inventory(ItemId, QuantityInStock),
	QuantityInStock >= QuantityWanted,
	!.

reorder(ItemId):-
	item(ItemId, ItemName, ReorderQuantity),
	inventory(ItemId, QuantityInStock),
	QuantityInStock < ReorderQuantity,
	format('Need to reorder ~w(~w).~n', [ItemName, ItemId]),
	!.
reorder(ItemId):-
	item(ItemId, ItemName, _),
	format('There is enough of ~w(~w) in stock.~n', [ItemName, ItemId]),
	!.
reorder(ItemName):-
	item(ItemId, ItemName, _),
	reorder(ItemId).

%%% ORDERS END %%%
