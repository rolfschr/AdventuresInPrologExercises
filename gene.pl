male(bart).
male(homer).
male(grandpa).
male(will).

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
parent(grandpa,will).
parent(will,joe).

motherOf(X) :- parent(M, X), female(M), write(M).
fatherOf(X) :- parent(F, X), male(F), write(F).

grandmotherOf(X) :- parent(P, X), motherOf(P).
grandfatherOf(X) :- parent(P, X), fatherOf(P).

sibling(X,Y) :- parent(P,X),parent(P,Y), X \= Y.

brotherOf(X, Y) :- sibling(X,Y), male(Y).
sisterOf(X, Y) :- sibling(X,Y), female(Y).

uncleOf(X,Y) :- parent(P,X),brotherOf(P,Y).
auntOf(X,Y) :- parent(P,X),sisterOf(P,Y).

cousinOf(X,Y) :- parent(P,X),sibling(P,S),parent(S,Y).

spouse(homer,marge).

married(X,Y) :- spouse(X,Y).
married(X,Y) :- spouse(Y,X).
