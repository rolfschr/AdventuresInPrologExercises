%  op(35,xfx,is_in).
:- op(35, fx, male).
male(bart).
male(homer).
male(grandpa).
male(will).

:- op(35, fx, female).
female(march).
female(lisa).
female(maggy).


:- op(35, xfx, parentOf).
parentOf(homer,bart).
parentOf(homer,lisa).
parentOf(homer,maggy).
parentOf(march,bart).
parentOf(march,lisa).
parentOf(march,maggy).
parentOf(grandpa,homer).
parentOf(grandpa,will).
parentOf(will,joe).

:- op(35, fx, motherOf).
motherOf(X) :- parentOf(M, X), female(M), write(M).
:- op(35, fx, fatherOf).
fatherOf(X) :- parentOf(F, X), male(F), write(F).

:- op(35, fx, grandmotherOf).
grandmotherOf(X) :- parentOf(P, X), motherOf(P).
:- op(35, fx, grandfatherOf).
grandfatherOf(X) :- parentOf(P, X), fatherOf(P).

:- op(35, xfx, grandparentOf).
grandparentOf(Parent, Child) :- parentOf(Q,Child), parentOf(Parent,Q).
:- op(35, xfx, grandchildOf).
grandchildOf(Child, Parent) :- parentOf(Parent,Q), parentOf(Q,Child).

:- op(35, xfx, siblingOf).
siblingOf(X,Y) :- parentOf(P,X),parentOf(P,Y), X \= Y.

:- op(35, xfx, brotherOf).
brotherOf(Y, X) :- siblingOf(X,Y), male(Y).
:- op(35, fx, sisterOf).
sisterOf(Y, X) :- siblingOf(X,Y), female(Y).

:- op(35, xfx, uncleByBloodOf).
uncleByBloodOf(Y, X) :- parentOf(P,X),brotherOf(P,Y).
:- op(35, xfx, uncleInLawOf).
uncleInLawOf(Y, X) :- parentOf(P,X),sisterOf(P,S),married(S,Y).

:- op(35, xfx, auntByBloodOf).
auntByBloodOf(Y, X) :- parentOf(P,X),sisterOf(P,Y).
:- op(35, xfx, auntInLawOf).
auntInLawOf(Y, X) :- parentOf(P,X),brotherOf(P,B),married(B,Y).

:- op(35, xfx, cousinOf).
cousinOf(X,Y) :- parentOf(P,X),siblingOf(P,S),parentOf(S,Y).

:- op(35, xfx, spouse).
spouse(homer,marge).

:- op(35, xfx, married).
married(X,Y) :- spouse(X,Y).
married(X,Y) :- spouse(Y,X).

% it's efficient to ask: give_desc_get_ance(bart, X)
give_desc_get_ance(D, A) :-
	parentOf(A, D).
give_desc_get_ance(D, A) :-
	parentOf(DirectAncestor, D),
	give_desc_get_ance(DirectAncestor, A).

% it's efficient to ask: give_ance_get_desc(grandpa, X)
give_ance_get_desc(A, D) :-
	parentOf(A, D).
give_ance_get_desc(A, D) :-
	parentOf(A, DirectDescendant),
	give_ance_get_desc(DirectDescendant, D).
