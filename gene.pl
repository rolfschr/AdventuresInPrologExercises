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
grandparent(Child, Parent) :- parent(Q,Child), parent(Parent,Q).

sibling(X,Y) :- parent(P,X),parent(P,Y), X \= Y.

brotherOf(X, Y) :- sibling(X,Y), male(Y).
sisterOf(X, Y) :- sibling(X,Y), female(Y).

% uncle by blood
uncleOf(X,Y) :- parent(P,X),brotherOf(P,Y).
% uncle in law
uncleOf(X,Y) :- parent(P,X),sisterOf(P,S),married(S,Y).

% aunt by blood
auntOf(X,Y) :- parent(P,X),sisterOf(P,Y).
% aunt in law
auntOf(X,Y) :- parent(P,X),brotherOf(P,B),married(B,Y).

cousinOf(X,Y) :- parent(P,X),sibling(P,S),parent(S,Y).

spouse(homer,marge).

married(X,Y) :- spouse(X,Y).
married(X,Y) :- spouse(Y,X).
