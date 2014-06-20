male(bart).
male(homer).
male(grandpa).

female(march).
female(lisa).
female(maggy).

parent(homer,bart).
parent(homer,lisa).
parent(homer,maggy).
parent(march,bart).
parent(march,lisa).
parent(march,maggy).
parent(grandpa,homer).

motherOf(X) :- parent(M, X), female(M), write(M).
fatherOf(X) :- parent(F, X), male(F), write(F).

grandmotherOf(X) :- parent(P, X), motherOf(P).
grandfatherOf(X) :- parent(P, X), fatherOf(P).
