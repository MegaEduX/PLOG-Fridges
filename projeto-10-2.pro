:- use_module(library(clpfd)).
:- use_module(library(lists)).

%
%	SWI-Prolog Source
%

flatten(List, FlatList) :-
	flatten(List, [], FlatList0), !,
	FlatList = FlatList0.

flatten(Var, Tl, [Var|Tl]) :-
	var(Var), !.

flatten([], Tl, Tl) :- !.

flatten([Hd|Tl], Tail, List) :- !,
	flatten(Hd, FlatHeadTail, List),
	flatten(Tl, Tail, FlatHeadTail).

flatten(NonList, Tl, [NonList|Tl]).

%	---

calculate_total_cost([], [], Result, Result).

calculate_total_cost([A | B], [C | D], CurrentSum, Result) :-
	X #= A * C,
	
	InnerResult #= CurrentSum + X,
	
	calculate_total_cost(B, D, InnerResult, Result).

calculate_outside([], [], Result, Result).

calculate_outside([A | B], [C | D], CurrentSum, Result) :-
	calculate_total_cost(A, C, CurrentSum, NewResult),
	
	calculate_outside(B, D, NewResult, Result).
	
%	---

projeto(ClienteFabrica, ResultValue) :-
	ClienteFabrica = [[C1, C2, C3], [C4, C5, C6], [C7, C8, C9]],
	
	flatten(ClienteFabrica, ClienteFabricaFlattened),
	
	domain(ClienteFabricaFlattened, 1, 1000),
	
	Custos = [[10, 20, 15], [5, 25, 10], [5, 5, 30]],
	
	C1 + C2 + C3 #=< 20,
	C4 + C5 + C6 #=< 20,
	C7 + C8 + C9 #=< 20,
	
	C1 + C4 + C7 #= 10,
	C2 + C5 + C8 #= 30,
	C3 + C6 + C9 #= 20,
	
	calculate_outside(Custos, ClienteFabrica, 0, ResultValue),
	
	labeling([minimize(ResultValue)], ClienteFabricaFlattened).
	