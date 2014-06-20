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
