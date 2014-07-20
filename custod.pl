% name, city, credit-rating
customer(tom,toronto,aaa).
customer(nancy,newcastle,bbb).
customer(bernd,berlin,aaa).
customer(pierre,paris,ccc).
customer(mishka,moscow,bbb).
customer(sven,stockholm,aaa).


% item(id,name,when-to-rebuy)
item(p1,lotr,10).
item(p2,lotf,10).
item(p3,ulyssis,0).
item(p4,great_expecations,10).
item(p5,lionking,5).

inventory(p1,32).
inventory(p2,24).
inventory(p3,3).
inventory(p4,2).
inventory(p5,23).

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

good_customer(X) :- customer(X,_,Rating), good_rating(Rating).

good_rating(Rating) :- atom_chars(Rating, [H|_]), H = a.
good_rating(Rating) :- atom_chars(Rating, [H|_]), H = b.
