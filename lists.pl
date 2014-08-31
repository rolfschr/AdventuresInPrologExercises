member(H,[H|_]).
member(X,[_|T]) :- member(X,T).

append([],X,[X]).
append([H|T1],X,[H|T2]) :-
	append(T1,X,T2).

remove(Element, [Element|Tail], Tail).
remove(Element, [H|Tail], [H|NewList]) :-
	remove(Element, Tail, NewList).

findAfter(ElementBefore, ElementToFind, [ElementBefore, ElementToFind|_]).
findAfter(ElementBefore, ElementToFind, [_|T]) :-
	findAfter(ElementBefore, ElementToFind, T).

split(PivotElement, [PivotElement|T], [], T).
split(PivotElement, [H|T], [H|ListBefore], ListAfter) :-
	split(PivotElement, T, ListBefore, ListAfter).

last([X], X).
last([_|T], X) :-
	last(T, X).

len([], 0).
len([_|T], Y) :-
	length(T, X), Y is X + 1.
